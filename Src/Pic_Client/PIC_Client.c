#include "PIC_Client.h"
#include <built_in.h>

unsigned int oldadc_rd = 0;
unsigned int adc_rd = 0;
PTcpStruct targetPacket;
unsigned int destinationPort = 0;
unsigned char destinationIp[4];
unsigned char destinationMac[6];
unsigned long sequenceNumber = 0;

void main() {
    PArpStruct arpData;
    PIpStruct ipData;
    char buffer[50];
    int i;
    int lessThan = 0;
    int moreThan = 0;

    ANSELA = 0x02;             // Configure RA1 pin as analog
    ANSELC = 0;
    ANSELD = 0;
    TRISD = 0;
    UART1_Init(9600);
    Delay_ms(100);
    UART1_Write_Text("\n\rStart \n\r");
    MACInit(void);
    Delay_ms(100);
    ChkLink();
    
    do {
        adc_rd = ADC_Read(1);    // get ADC value from 1st channel

        lessThan = oldadc_rd - FluxLimit;
        moreThan = oldadc_rd + FluxLimit;

        if (ChkPck()) {
            //Check ARP
            arpData = (PArpStruct) Packet;
            if (arpData->eth.Type == 0x0608) // Arp Request = 0x0806
            {
                if (!HandleArpPackage(arpData))
                {
                    UART1_Write_Text("Ukendt device");
                }
            }
            //Check IP
            else if (arpData->eth.Type == 0x0008) // IP = 0x0800
            {
                ipData = (PIpStruct) Packet;
                if (IsThisDevice(ipData->Ip.DestAddr)) {
                    switch (ipData->Ip.Proto)
                    {
                        case PROTO_ICMP:
                            Icmp((PIcmpStruct) Packet, PckLen);
                            break;
                        case PROTO_UDP:
                            HandleUdpPackage((PUdpStruct) Packet);
                            break;
                        case PROTO_TCP:
                            HandleTcpPackage((PTcpStruct) Packet);
                            break;
                    }
                }
            }
        }
        else if (destinationPort != 0 && (lessThan > adc_rd || moreThan < adc_rd))
        {
            oldadc_rd = adc_rd;
            SendMessage();
        }
    } while (true);
}

void SendMessage(void) {
    PTcpStruct tcpPacket;
    PPseudoStruct pseudoData;
    int dataLen;
    
    intToShort.IntVal = adc_rd;
    
    tcpPacket->tcp.SourcePort = 0x8D13; //5005
    tcpPacket->tcp.DestPort = destinationPort;
    tcpPacket->uddata[0] = IntToShort.ShortVal[0];
    tcpPacket->uddata[1] = IntToShort.ShortVal[1];
    tcpPacket->tcp.DataOffset.Reserved3 = 0x00;
    tcpPacket->tcp.DataOffset.Val = 0x05;
    tcpPacket->tcp.UrgentPointer = 0x00;
    
    TCPDataLen = dataLen - (tcpPacket->tcp.DataOffset.Val * 4);
    sequenceNumber += TCPDataLen;

    tcpPacket->tcp.SeqNumber = SwapByteOrder(sequenceNumber);
    tcpPacket->tcp.AckNumber = 0x00000000;
    tcpPacket->tcp.Flags.byte = 0; //dis is gud coed
    //tcpPacket->tcp.Flags.bits.flagFIN = 0;
    //tcpPacket->tcp.Flags.bits.flagSYN = 0;
    //tcpPacket->tcp.Flags.bits.flagRST = 0;
    tcpPacket->tcp.Flags.bits.flagACK = 1;
    //tcpPacket->tcp.Flags.bits.flagURG = 0;
    tcpPacket->tcp.Flags.bits.flagPSH = 1;

    dataLen = sizeof(IpStruct) + 2;


    memcpy(tcpPacket->ip.ScrAddr, destinationIp, 4);
    memcpy(tcpPacket->ip.DestAddr, MyIpAddr, 4);
    
    TCPLen = sizeof(TcpHdr) + 2; // 2 for 2 bytes of data.
    
    tcpPacket->ip.Proto = PROTO_TCP;
    tcpPacket->ip.Ver_Len = 0x45;
    tcpPacket->ip.Tos = 0x00;
    tcpPacket->ip.PktLen = _SWAP(sizeof(IpHdr) + TCPLen);   //sizeof(TcpHdr) + 2)
    tcpPacket->ip.Id = 0x287;
    tcpPacket->ip.Offset = 0x0000;
    tcpPacket->ip.Ttl = 128;
    tcpPacket->ip.PktLen = _SWAP(dataLen);

    memcpy(tcpPacket->eth.ScrMac, destinationMac, 6);
    memcpy(tcpPacket->eth.DestMac, myMacAddr, 6);
    
    tcpPacket->eth.Type = 0x0008;

    pseudoData = (PPseudoStruct) PseudoPacket;
    Tcp_CheckSum((PPseudoStruct) pseudoData, (PTcpStruct) tcpPacket);

    UART1_Write_Text("Writing packet!");
    Trans_TCP((PTcpStruct) tcpPacket, PckLen, TCPLen);   //(TCPLen + TcpDataLen)
}

bool HandleArpPackage(PArpStruct arpData) {
    UART1_Write_Text("\n\rARP Pakke. ");
    if (arpData->arp.HwType == 0x0100 && // HwType = 0001
        arpData->arp.PrType == 0x0008 && // PrType = 0x0800
        arpData->arp.HwLen == 0x06 && arpData->arp.PrLen == 0x04 &&
        arpData->arp.OpCode == 0x0100 &&
        IsThisDevice(arpData->arp.TIpAddr)) {
        Arp((PArpStruct) arpData, PckLen);
        return true;
    }
    else{
      return false;
    }
}

void HandleUdpPackage(PUdpStruct udpData)
{
    PPseudoStruct pseudoData;
    UART1_Write_Text("UDP Pakke!!!\n\r");
    if (Udp_Rec((PUdpStruct) UdpData, PckLen)) {
        pseudoData = (PPseudoStruct) PseudoPacket;
        udp_CheckSum(pseudoData, (PUdpStruct) UdpData);
        Udp_Trans((PUdpStruct) UdpData, PckLen);
    }
}

void HandleTcpPackage(PTcpStruct tcpData)
{
    PPseudoStruct pseudoData;
    char buffer[20];
    
    UART1_Write_Text("TCP Pakke modtaget\n\r");
    if (tcpData->tcp.DestPort == 0x8D13) //Port TCP port 5005 0x138D
    {
        UART1_Write_Text("TCP Pakke modtaget port 5005\n\r");

        tcpData = (PTcpStruct) Packet;
        pseudoData = (PPseudoStruct) PseudoPacket;
        Tcp_CheckSum((PPseudoStruct) pseudoData, (PTcpStruct) tcpData);

        TCPFlags.byte = tcpData->tcp.Flags.byte;
        tcpData->tcp.Flags.byte = 0;

        if (TCPFlags.byte == SYN) {
            UART1_Write_Text("TCP SYN Pakke modtaget\n\r");
            TCP_Ack_Num = tcpData->tcp.SeqNumber;
            TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
            TCP_Ack_Num++;
            TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
            tcpData->tcp.AckNumber = TCP_Ack_Num;

            tcpData->tcp.SeqNumber = 0x78563412; //0x12345678

            tcpData->tcp.Flags.bits.flagSYN = 1;
            tcpData->tcp.Flags.bits.flagACK = 1;

            TCPLen = tcpData->tcp.DataOffset.Val * 4;
            Trans_TCP((PTcpStruct) tcpData, PckLen, TCPLen);

            UART1_Write_Text("TCP SYN Pakke sendt\n\r");
        } else if (TCPFlags.byte == PSHACK) {
            unsigned short i;
            unsigned DataLen;
            UART1_Write_Text("TCP ACK DataPakke modtaget\n\r");

            DataLen = _SWAP((tcpData->ip.PktLen));
            TCPDataLen = DataLen - ((tcpData->tcp.DataOffset.Val * 4) + 20);
            if (TCPDataLen) {
                TCP_Ack_Num = tcpData->tcp.SeqNumber;
                TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
                TCP_Ack_Num += TCPDataLen;
                sequenceNumber = TCP_Ack_Num;
                sprintf(buffer, "%d", sequenceNumber);
                UART1_Write_Text("\n\rSequence: ");
                UART1_Write_Text(buffer);
                UART1_Write_Text("\n\r");
                
                TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);

                sprintf(buffer, "%d", sequenceNumber);
                UART1_Write_Text("\n\rAfter: ");
                UART1_Write_Text(buffer);
                UART1_Write_Text("\n\r");

                tcpData->tcp.SeqNumber = tcpData->tcp.AckNumber;
                tcpData->tcp.AckNumber = TCP_Ack_Num;

                tcpData->tcp.Flags.bits.flagACK = 1;

                UART1_Write_Text("\n\r");
                // tcpData->uddata[DataLen] = 0;
                UART1_Write_Text(tcpData->uddata);
                UART1_Write_Text("\n\r");

                for (i = 0; i <= TCPDataLen; i++) {
                    if (tcpData->uddata[i] > 'a' && tcpData->uddata[i] < 'z')
                        tcpData->uddata[i].B5 = 0;
                }
                tcpData->uddata[TCPDataLen] = 0;

                UART1_Write_Text(tcpData->uddata);

                TCPLen = tcpData->tcp.DataOffset.Val * 4;

                pseudoData = (PPseudoStruct) PseudoPacket;
                Tcp_CheckSum((PPseudoStruct) pseudoData, (PTcpStruct) tcpData);
                Trans_TCP((PTcpStruct) tcpData, PckLen, (TCPLen + TcpDataLen));

                UART1_Write_Text("\n\rTCP ACK Pakke sendt\n\r");
            }
            
            UART1_Write_Text("\n\rGemmer data");
            destinationPort = tcpData->tcp.SourcePort;

            memcpy(destinationMac, tcpData->eth.ScrMac, 6);
            memcpy(destinationIp, tcpData->ip.ScrAddr, 4);
            
        } else if (TCPFlags.byte == FINACK) {
            UART1_Write_Text("TCP FIN ACK Pakke modtaget\n\r");
            TCP_Ack_Num = tcpData->tcp.SeqNumber;
            TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
            TCP_Ack_Num++;
            TCP_Ack_num = SwapByteOrder(TCP_Ack_Num);

            tcpData->tcp.SeqNumber = tcpData->tcp.AckNumber;
            tcpData->tcp.AckNumber = TCP_Ack_Num;

            tcpData->tcp.Flags.bits.flagACK = 1;
            tcpData->tcp.Flags.bits.flagFIN = 1;

            TCPLen = tcpData->tcp.DataOffset.Val * 4;
            Trans_TCP((PTcpStruct) tcpData, PckLen, TCPLen);
            UART1_Write_Text("TCP ACK - FIN Pakke sendt\n\r");
        }
    }
}

bool IsThisDevice(unsigned short ipAddr[])
{
    if (ipAddr[0] == MyIpAddr[0] &&
        ipAddr[1] == MyIpAddr[1] &&
        ipAddr[2] == MyIpAddr[2] &&
        ipAddr[3] == MyIpAddr[3])
    {
        return true;
    }
    else
    {
      return false;
    }
}

unsigned int Tcp_CheckSum(PPseudoStruct TcpPseudoData, PTcpStruct TcpData) {
    //Pseudo Header
    unsigned short i;
    unsigned DataLen, TcpCkSum;
    unsigned TcpDataLen, TcpHdrLen;

    DataLen = _SWAP(TcpData->ip.PktLen);
    TCPDataLen = DataLen - ((TcpData->tcp.DataOffset.Val * 4) + 20);

    TcpHdrLen = (TcpData->tcp.DataOffset.Val * 4) + TCPDataLen;

    for (i = 0; i <= 3; i++) {
        TcpPseudoData->SrcIP[i] = TcpData->ip.ScrAddr[i];
        TcpPseudoData->DestIP[i] = TcpData->ip.DestAddr[i];
    }
    TcpPseudoData->Zero = 0;
    TcpPseudoData->Proto = PROTO_TCP; //TCP
    TcpPseudoData->DataLen = _SWAP(TcpHdrLen);

    UdPacket((unsigned short * ) TcpPseudoData, 12);
    UART1_Write_Text("TCP pseudo Trans Pakke\n\r");

    TcpCkSum = Cksum(UDASTART, 12, 0); //Tcp Pseudo checksum seed = 0

    ShowPacket((unsigned short * ) TcpPseudoData, 22);
    return TcpCkSum;
}


void Trans_TCP(PTcpStruct TcpData, unsigned short PckLen, unsigned TCPLen) {
    unsigned int temp;

    SwapAddr((PIpStruct) TcpData);

    temp = TcpData->Tcp.SourcePort; // Swap portNr.
    TcpData->tcp.SourcePort = TcpData->tcp.DestPort;
    TcpData->tcp.DestPort = temp;

    TcpData->tcp.Checksum = 0;

    TxPacket((unsigned short * ) TcpData, PckLen, FALSE); //Fill Eth Buffer Don't send

    TcpData->tcp.Checksum = CkSum(sizeof(IpStruct), TCPLen, TRUE);; // Checksum with seed

    //ShowPacket((unsigned short * ) TcpData, PckLen);

    // ShowPacket ((unsigned short*)TcpData, PckLen);
    //UART1_Write_Text("\n\rTxPckt");
    TxPacket((unsigned short * ) TcpData, PckLen, TRUE); //Fill Eth Buffer And send
}

unsigned short Udp_Rec(PUdpStruct PUdpData, unsigned short PckLen) {
    unsigned short TekstLen;
    UART1_Write_Text("UDP Pakke modtaget\n\r");
    if (PUdpData->udp.DestPort == 0x8D13) // Port 5005
    {
        TekstLen = SWAP(PUdpData->udp.Len) - 8; //Tekst længde - UDP Hdr.
        PUdpData->uddata[TekstLen] = 0;
        UART1_Write_Text(PUdpData->uddata);
        UART1_Write_Text("\n\r");
        UART1_Write_Text("UDP Pakke modtaget port 5005\n\r");
        return TRUE;
    } else return FALSE;
}



unsigned int Udp_CheckSum(PPseudoStruct UdpPseudoData, PUdpStruct UdpData) {
    unsigned short i;
    unsigned CheckSum;

    for (i = 0; i <= 3; i++) {
        UdpPseudoData->SrcIP[i] = UdpData->ip.ScrAddr[i];
        UdpPseudoData->DestIP[i] = UdpData->ip.DestAddr[i];
    }
    UdpPseudoData->Zero = 0;
    UdpPseudoData->Proto = 17; //UDP
    UdpPseudoData->DataLen = UdpData->udp.Len;
    UdPacket((unsigned short * ) UdpPseudoData, 12);
    UART1_Write_Text("UDP pseudo Trans Pakke\n\r");

    CheckSum = Cksum(UDASTART, 12, 0); //Udp Pseudo checksum seed = 0

    WordToStr(Checksum, HexStr);
    UART1_Write_Text("\n\rPseudo Checksum  :");
    UART1_Write_Text(HexStr);
    UART1_Write_Text("\n\r");

    //  ShowPacket ((unsigned short*)UdpPseudoData, 12);
    return CheckSum;
}


void Udp_Trans(PUdpStruct PUdpData, unsigned short PckLen) {

    unsigned int temp;
    unsigned short TekstLen, i;

    UART1_Write_Text("UDP Trans Pakke\n\r");
    UdpLen = _SWAP(PUdpData->udp.Len);
    TekstLen = UdpLen - 8; //Tekst længde - UDP Hdr.
    SwapAddr((PIpStruct) PUdpData);
    temp = PUdpData->udp.SrcPort;
    PUdpData->udp.SrcPort = PUdpData->udp.DestPort;
    PUdpData->udp.DestPort = temp;
    PUdpData->udp.CkSum = 0;

    for (i = 0; i <= TekstLen; i++) {
        if (PUdpData->uddata[i] >= 'a' && PUdpData->uddata[i] <= 'z')
            PUdpData->uddata[i].B5 = 0;
    }
    PUdpData->uddata[TekstLen] = 0;

    TxPacket((unsigned short * ) PUdpData, PckLen, FALSE); //Fill Eth Buffer Don't send

    PUdpData->udp.CkSum = Cksum(sizeof(IpStruct), UdpLen, 1); // Checksum with seed
    ShowPacket((unsigned short * ) PUdpData, PckLen);
    TxPacket((unsigned short * ) PUdpData, PckLen, TRUE); //Fill Eth Buffer And send
}

void Icmp(PIcmpStruct PIcmpData, unsigned short PckLen) {
    unsigned int len;
    PIcmpData->icmp.Type = 0x00;
    PIcmpData->icmp.Code = 0x00; //Set Echo Reply
    PIcmpData->icmp.CkSum = 0x0000; //Clear ICMP checksum
    PIcmpData->ip.CkSum = 0x0000; //Clear IP checksum
    SwapAddr((PIpStruct) PIcmpData);
    TxPacket((unsigned short * ) PIcmpData, PckLen, 0); //Fill Eth Buffer Don't send

    PIcmpData->ip.CkSum = CkSum(sizeof(EthHdr), sizeof(IpHdr), 0);

    len = SWAP(PIcmpData->ip.PktLen);
    PIcmpData->icmp.CkSum = CkSum(sizeof(IpStruct), PckLen - sizeof(IpStruct), 0); //ICMP hdr + Data Payload
    TxPacket((unsigned short * ) PIcmpData, PckLen, 1); //Fill Eth Buffer And send
}

void Arp(PArpStruct PArpData, unsigned short PckLen) {
    unsigned short i;
    unsigned Len;

    PArpData->arp.OpCode = _SWAP(0x0002);
    for (i = 0; i <= 5; i++) {
        PArpData->eth.DestMac[i] = PArpData->eth.ScrMac[i];
        PArpData->arp.THwAddr[i] = PArpData->arp.SHwAddr[i];
        PArpData->eth.ScrMac[i] = MyMacAddr[i];
        PArpData->arp.SHwAddr[i] = MyMacAddr[i];
    }
    for (i = 0; i <= 3; i++) {
        PArpData->arp.TIpAddr[i] = PArpData->arp.SIpAddr[i];
        PArpData->arp.SIpAddr[i] = MyIpAddr[i];
    }
    Len = sizeof(ArpStruct);
    TxPacket((unsigned short * ) PArpData, Len, 1);
}

void UdPacket(unsigned short * Data, unsigned len) {
    WriteReg(EUDAWRPT, UDASTART);
    WriteReg(EUDARDPT, UDASTART);
    WriteMemoryWindow(UDA_WINDOW, Data, len);
    //  ShowPacket (Data, len);
}

void TxPacket(unsigned short * PkData, unsigned len, unsigned short TX) {
    unsigned read;
    do {
        read = ReadReg(ECON1);
    } while (Read & ECON1_TXRTS);
    WriteReg(ERXWRPT, TXSTART);
    WriteMemoryWindow(RX_WINDOW, PkData, len);
    if (TX) {
        WriteReg(ETXST, (unsigned) 0x0000);
        WriteReg(ETXLEN, len);
        do {
            read = ReadReg(ECON1);
        } while (Read & ECON1_TXRTS);

        ChkLink();
    }
}

unsigned long swapByteOrder(unsigned long ui) {
    ui = (ui >> 24) |
        ((ui << 8) & 0x00FF0000) |
        ((ui >> 8) & 0x0000FF00) |
        (ui << 24);
    return ui;
}

void SwapAddr(PIpStruct ipData) {
    unsigned short i;

    for (i = 0; i <= 5; i++) {
        ipData->eth.DestMac[i] = ipData->eth.ScrMac[i];
        ipData->eth.ScrMac[i] = MyMacAddr[i];
    }
    for (i = 0; i <= 3; i++) {
        ipData->ip.DestAddr[i] = ipData->ip.ScrAddr[i];
        ipData->ip.Scraddr[i] = MyIpAddr[i];
    }
}


unsigned int CkSum(unsigned offset, unsigned Len, unsigned short Seed) {
    unsigned Read;

    do {
        Read = ReadReg(ECON1);
    } while (Read & ECON1_DMAST);

    BFCREG(ECON1, ECON1_DMACPY);
    BFCREG(ECON1, ECON1_DMANOCS);
    if (Seed)
        BFSREG(ECON1, ECON1_DMACSSD);
    else
        BFCREG(ECON1, ECON1_DMACSSD);

    WriteReg(EDMAST, TXSTART + offset);
    WriteReg(EDMALEN, Len);

    BFSREG(ECON1, ECON1_DMAST);
    do {
        read = ReadReg(ECON1);
    } while (Read & ECON1_DMAST);

    read = (ReadReg(EDMACS));
    return read;
}

/******************************************************************************
 * Function:        void ENC100Init(void)
 *
 * PreCondition:    None
 *
 * Input:           None
 *
 * Output:          None
 *
 * Side Effects:    None
 *
 * Overview:        MACInit sets up the PIC's SPI module and all the
 *                                        registers in the ENCX24J600 so that normal operation can
 *                                        begin.
 *
 * Note:            None
 *****************************************************************************/
void MACInit(void) {
        // Chip Select line from PIC

        DeassertChipSelect();

        ConfigureSPIModule();
        ClearSPIDoneFlag();

        // Perform a reliable reset

        SendSystemReset();

        RegValue = ReadReg(MAADR1);
        myMacAddr[0] = LOW(RegValue);
        myMacAddr[1] = HIGH(RegValue);
        RegValue = ReadReg(MAADR2);
        myMacAddr[2] = LOW(RegValue);
        myMacAddr[3] = HIGH(RegValue);
        RegValue = ReadReg(MAADR3);
        myMacAddr[4] = LOW(RegValue);
        myMacAddr[5] = HIGH(RegValue);

        // Initialize RX tracking variables and other control state flags

        NextPacketPointer = RXSTART;
        WriteReg(ETXST, TXSTART);
        WriteReg(ERXST, RXSTART);
        WriteReg(ERXRDPT, RXSTART);
        WriteReg(ERXTAIL, RXEND - 2);

        // Set PHY Auto-negotiation to support 10BaseT Half duplex,
        // 10BaseT Full duplex, 100BaseTX Half Duplex, 100BaseTX Full Duplex,
        // and symmetric PAUSE capability
        WritePHYReg(PHANA, PHANA_ADPAUS0 | PHANA_AD10FD | PHANA_AD10 | PHANA_AD100FD | PHANA_AD100 | PHANA_ADIEEE0);

        // Enable RX packet reception
        EXECUTE0(ENABLERX);
    } //end MACInit

unsigned ChkPck() {
    unsigned short PckCnt;
    
    RegValue = ReadReg(EIR);
    if (!(RegValue & EIR_PKTIF))
    {
        return 0;
    }

    RegValue = ReadReg(ESTAT);
    PckCnt = LOW(RegValue);
    if (PckCnt) {
        PckLen = GetFrame();
        return PckLen;
    }
    return 0;
}

unsigned GetFrame() {
    unsigned RxLen;
    unsigned short PckHdr[8];

    WriteReg(ERXRDPT, NextPacketPointer);

    ReadMemoryWindow(RX_WINDOW, PckHdr, 8);
    RXData = (PRXStruct) PckHdr;

    NextPacketPointer = RXData->NextPtr;
    RxLen = RXData->ByteCount;
    if (RxLen > 200) Rxlen = 200;

    ReadMemoryWindow(RX_WINDOW, packet, RxLen);

    WriteReg(ERXTAIL, RXData->NextPtr - 2);

    RxLen -= 4; //!!!!!!!!
    Execute0(SETPKTDEC);

    if (RXData->ReceiveOk) return (RxLen);
    else return 0;
}


/******************************************************************************
 * Function:        void ChkLink(void)
 *
 *
 * Input:           None
 *
 * Output:          None
 *
 * Side Effects:    None
 *
 * Overview:        ChkLink causes the current TX packet to be sent out on
 *                  the Ethernet medium.  The hardware MAC will take control
 *                  and handle CRC generation, collision retransmission and
 *                  other details.
 *
 * Note:            The packet can be modified and transmitted again by calling
 *                  MACFlush() again.  Until TXPacket() is
 *                  called (in the TX data area), the data in the TX buffer
 *                  will not be corrupted.
 *****************************************************************************/

void ChkLink(void) {
    unsigned w;

    // Check to see if the duplex status has changed.  This can
    // change if the user unplugs the cable and plugs it into a
    // different node.  Auto-negotiation will automatically set
    // the duplex in the PHY, but we must also update the MAC
    // inter-packet gap timing and duplex state to match.
    if (ReadReg(EIR) & EIR_LINKIF) {
        BFCReg(EIR, EIR_LINKIF);

        // Update MAC duplex settings to match PHY duplex setting
        w = ReadReg(MACON2);
        if (ReadReg(ESTAT) & ESTAT_PHYDPX) {
            // Switching to full duplex
            WriteReg(MABBIPG, 0x15);
            w |= MACON2_FULDPX;
        } else {
            // Switching to half duplex
            WriteReg(MABBIPG, 0x12);
            w &= ~MACON2_FULDPX;
        }
        WriteReg(MACON2, w);
    }

    // Start the transmission, but only if we are linked.  Supressing
    // transmissing when unlinked is necessary to avoid stalling the TX engine
    // if we are in PHY energy detect power down mode and no link is present.
    // A stalled TX engine won't do any harm in itself, but will cause the
    // MACIsTXReady() function to continuously return FALSE, which will
    // ultimately stall the Microchip TCP/IP stack since there is blocking code
    // elsewhere in other files that expect the TX engine to always self-free
    // itself very quickly.

    do {
        RegValue = ReadReg(ESTAT);
    } while (!(RegValue & ESTAT_PHYLNK));

    EXECUTE0(SETTXRTS);

    do {
        RegValue = ReadReg(ECON1);
    } while (RegValue & ECON1_TXRTS);
}

/******************************************************************************
 * Function:        void SendSystemReset(void)
 *
 * PreCondition:    SPI or PSP bus must be initialized (done in MACInit()).
 *
 * Input:           None
 *
 * Output:          None
 *
 * Side Effects:    None
 *
 * Overview:        SendSystemReset reliably resets the Ethernet controller.
 *                                        It resets all register contents (except for COCON bits of
 *                                        ECON2) and returns the device to the power on default state.
 *                                        This function should be called instead of directly
 *                                        attempting to perform a reset via the ECON2<ETHRST> bit.
 *                                        If using the PSP, SendSystemReset also does basic checks to
 *                                        look for unsoldered pins or solder bridges on the PSP pins.
 *
 * Note:            This function is a blocking function and will lock up the
 *                                        application if a non-recoverable problem is present.
 *                                        Possible non-recoverable problems include:
 *                                                - SPI module not configured correctly
 *                                                - PMP module not configured correctly
 *                                                - HardwareProfile pins not defined correctly
 *                                                - Solder bridge on SPI/PSP/PMP lines
 *                                                - Unsoldered pins on SPI/PSP/PMP lines
 *                                                - 25MHz Ethernet oscillator not running
 *                                                - Vdd lower than ENCX24J600 operating range
 *                                                - I/O levels out of range (for example if the PIC is at
 *                                                  2V without level shifting)
 *                                                - Bus contention on SPI/PSP/PMP lines with other slaves
 *                                                - One or more Vdd or Vss pins are not connected.
 *****************************************************************************/
void SendSystemReset(void) {
        // Perform a reset via the SPI interface
        do {
            // Set and clear a few bits that clears themselves upon reset.
            // If EUDAST cannot be written to and your code gets stuck in this
            // loop, you have a hardware problem of some sort (SPI or PMP not
            // initialized correctly, I/O pins aren't connected or are
            // shorted to something, power isn't available, etc.)

            do {
                WriteReg(EUDAST, 0x1234);
            } while (ReadReg(EUDAST) != 0x1234u);

            // Issue a reset and wait for it to complete
            Execute0(SETETHRST);
            vCurrentBank = 0;
            while ((ReadReg(ESTAT) & (ESTAT_CLKRDY | ESTAT_RSTDONE | ESTAT_PHYRDY)) != (ESTAT_CLKRDY | ESTAT_RSTDONE | ESTAT_PHYRDY));
            Delay_us(30);


            // Check to see if the reset operation was successful by
            // checking if EUDAST went back to its reset default.  This test
            // should always pass, but certain special conditions might make
            // this test fail, such as a PSP pin shorted to logic high.
        } while (ReadReg(EUDAST) != 0x0000u);

        // Really ensure reset is done and give some time for power to be stable
        Delay_Ms(1);

    } //end SendSystemReset

/******************************************************************************
 * Function:        unsigned short int ReadReg(unsigned short int wAddress)
 *
 * PreCondition:    SPI/PSP bus must be initialized (done in MACInit()).
 *
 * Input:           wAddress: Address of SFR register to read from.
 *                  The LSb is ignored and treated as '0' always.
 *
 * Output:          unsigned short int value of register contents
 *
 * Side Effects:    None
 *
 * Overview:        Selects the correct bank (if needed), and reads the
 *                  corresponding 16-bit register
 *
 * Note:            This routine cannot be used to read PHY registers.
 *                                        Use the ReadPHYReg() function to read from PHY registers.
 *****************************************************************************/
unsigned ReadReg(unsigned short int wAddress) {
        // SPI mode
        {
            unsigned w;
            unsigned char vBank;

            // See if we need to change register banks
            vBank = ((unsigned char) wAddress) & 0xE0;
            if (vBank <= (0x3u << 5)) {
                if (vBank != vCurrentBank) {
                    if (vBank == (0x0u << 5))
                        Execute0(B0SEL);
                    else if (vBank == (0x1u << 5))
                        Execute0(B1SEL);
                    else if (vBank == (0x2u << 5))
                        Execute0(B2SEL);
                    else if (vBank == (0x3u << 5))
                        Execute0(B3SEL);

                    vCurrentBank = vBank;
                }

                w = Execute2(RCR | (wAddress & 0x1F), 0x0000);
            } else {
                unsigned long dw = Execute3(RCRU, (unsigned short int) wAddress);
                ((unsigned char * ) & w)[0] = ((unsigned char * ) & dw)[1];
                ((unsigned char * ) & w)[1] = ((unsigned char * ) & dw)[2];
            }

            return w;
        }
    } //end ReadReg

/******************************************************************************
 * Function:        void ReadMemoryWindow(unsigned vWindow, unsigned short *vData, unsigned wLength)
 *
 * PreCondition:    None
 *
 * Input:           vWindow: UDA_WINDOW, GP_WINDOW, or RX_WINDOW corresponding
 *                                                         to the window register to read from
 *                                        *vData: Pointer to local PIC RAM which will be written
 *                                                        with data from the ENC624J600 Family.
 *                                        wLength: Number of bytes to copy from window to vData
 *
 * Output:          None
 *
 * Side Effects:    None
 *
 * Overview:        Copys 0 or more bytes from the ENC624J600 Family RAM using
 *                                        one of the UDA, TX, or RX read window pointers.  This
 *                                        pointer is incremented by the number of bytes read.
 *                                        However, if using a 16-bit parallel interface, the pointer
 *                                        will be incremented by 1 extra if the length parameter is
 *                                        odd to ensure 16-bit alignment.
 *
 * Note:            None
 *****************************************************************************/
void ReadMemoryWindow(unsigned short vWindow, unsigned short * vData, unsigned wLength) {
    unsigned short vOpcode;

    vOpcode = RBMUDA;
    if (vWindow == GP_WINDOW)
        vOpcode = RBMGP;
    if (vWindow == RX_WINDOW)
        vOpcode = RBMRX;

    ReadN(vOpcode, vData, wLength);
}

void ReadN(unsigned char vOpcode, unsigned char * vData, unsigned wDataLen) {
    volatile unsigned char vDummy;

    AssertChipSelect();
    ClearSPIDoneFlag();
    SSPBUF = vOpcode; // Send the command/opcode
    WaitForDatabyte();
    vDummy = SSPBUF;
    while (wDataLen--) {
        SSPBUF = 0x00;
        WaitForDatabyte(); * vData = SSPBUF;
        vData++;
    }
    DeassertChipSelect();


}

/******************************************************************************
 * Function:        unsigned short int ReadPHYReg(unsigned char Register)
 *
 * PreCondition:    SPI bus must be initialized (done in MACInit()).
 *
 * Input:           Address of the PHY register to read from.
 *
 * Output:          16 bits of data read from the PHY register.
 *
 * Side Effects:    None
 *
 * Overview:        ReadPHYReg performs an MII read operation.  While in
 *                                        progress, it simply polls the MII BUSY bit wasting time
 *                                        (25.6us).
 *
 * Note:            None
 *****************************************************************************/
unsigned ReadPHYReg(unsigned char Register) {
        unsigned wResult;

        // Set the right address and start the register read operation
        WriteReg(MIREGADR, 0x0100 | Register);
        WriteReg(MICMD, MICMD_MIIRD);

        // Loop to wait until the PHY register has been read through the MII
        // This requires 25.6us
        while (ReadReg(MISTAT) & MISTAT_BUSY);

        // Stop reading
        WriteReg(MICMD, 0x0000);

        // Obtain results and return
        wResult = ReadReg(MIRD);

        return wResult;
    } //end ReadPHYReg

/******************************************************************************
 * Function:        WriteReg(unsigned short int wAddress, unsigned short int wValue)
 *
 * PreCondition:    SPI/PSP bus must be initialized (done in MACInit()).
 *
 * Input:           wAddress: Address of the SFR register to write to.
 *                                        16-bit unsigned short int to be written into the register.
 *
 * Output:          None
 *
 * Side Effects:    None
 *
 * Overview:        Selects the correct bank (if using the SPI and needed), and
 *                                        writes the corresponding 16-bit register with wValue.
 *
 * Note:            This routine cannot write to PHY registers.  Use the
 *                                        WritePHYReg() function for writing to PHY registers.
 *****************************************************************************/
void WriteReg(unsigned short int wAddress, unsigned wValue) {
        // SPI mode
        {
            unsigned char vBank;

            // See if we need to change register banks
            vBank = ((unsigned char) wAddress) & 0xE0;
            if (vBank <= (0x3u << 5)) {
                if (vBank != vCurrentBank) {
                    if (vBank == (0x0u << 5))
                        Execute0(B0SEL);
                    else if (vBank == (0x1u << 5))
                        Execute0(B1SEL);
                    else if (vBank == (0x2u << 5))
                        Execute0(B2SEL);
                    else if (vBank == (0x3u << 5))
                        Execute0(B3SEL);

                    vCurrentBank = vBank;
                }

                Execute2(WCR | (wAddress & 0x1F), wValue);
            } else {
                unsigned long dw;
                ((unsigned char * ) & dw)[0] = (unsigned char) wAddress;
                ((unsigned char * ) & dw)[1] = ((unsigned char * ) & wValue)[0];
                ((unsigned char * ) & dw)[2] = ((unsigned char * ) & wValue)[1];
                Execute3(WCRU, dw);
            }

        }
    } //end WriteReg

/******************************************************************************
 * Function:        void WriteMemoryWindow(BYTE vWindow, BYTE *vData, WORD wLength)
 *
 * PreCondition:    None
 *
 * Input:           vWindow: UDA_WINDOW, GP_WINDOW, or RX_WINDOW corresponding
 *                                                         to the window register to write to
 *                                        *vData: Pointer to local PIC RAM which contains the
 *                                                        source data
 *                                        wLength: Number of bytes to copy from vData to window
 *
 * Output:          None
 *
 * Side Effects:    None
 *
 * Overview:        Copys 0 or more bytes from CPU RAM to the ENCX24J600
 *                                        Family RAM using one of the UDA, TX, or RX write window
 *                                        pointers.  This pointer is incremented by the number of
 *                                        bytes writen.
 *
 * Note:            None
 *****************************************************************************/
void WriteMemoryWindow(unsigned short vWindow, unsigned short * vData, unsigned wLength) {
    unsigned short vOpcode;

    vOpcode = WBMUDA;
    if (vWindow & GP_WINDOW)
        vOpcode = WBMGP;
    if (vWindow & RX_WINDOW)
        vOpcode = WBMRX;

    WriteN(vOpcode, vData, wLength);
}

void WriteN(unsigned char vOpcode, unsigned short * vData, unsigned wDataLen) {
    volatile unsigned char vDummy;

    AssertChipSelect();
    ClearSPIDoneFlag();
    SSPBUF = vOpcode; // Send the command/opcode
    WaitForDatabyte();
    vDummy = SSPBUF;

    while (wDataLen--) {
        SSPBUF = * vData++;
        WaitForDatabyte();
        vDummy = SSPBUF;
    }
    DeassertChipSelect();

}


/******************************************************************************
 * Function:        WritePHYReg
 *
 * PreCondition:    SPI bus must be initialized (done in MACInit()).
 *
 * Input:           Address of the PHY register to write to.
 *                                        16 bits of data to write to PHY register.
 *
 * Output:          None
 *
 * Side Effects:    None
 *
 * Overview:        WritePHYReg performs an MII write operation.  While in
 *                                        progress, it simply polls the MII BUSY bit wasting time.
 *
 * Note:            None
 *****************************************************************************/
void WritePHYReg(unsigned char Register, unsigned short int Data) {
        // Write the register address
        WriteReg(MIREGADR, 0x0100 | Register);

        // Write the data
        WriteReg(MIWR, Data);

        // Wait until the PHY register has been written
        while (ReadReg(MISTAT) & MISTAT_BUSY);
    } //end WritePHYReg

/******************************************************************************
 * Function:        BFSReg(unsigned short int wAddress, unsigned short int wBitMask)
 *                                        void BFCReg(unsigned short int wAddress, unsigned short int wBitMask)
 *
 * PreCondition:    None
 *
 * Input:           7 bit address of the register to write to.
 *                                        16-bit unsigned short int bitmask to set/clear in the register.
 *
 * Output:          None
 *
 * Side Effects:    None
 *
 * Overview:        Sets/clears bits in Ethernet SFR registers
 *
 * Note:            These functions cannot be used to access ESFR registers.
 *****************************************************************************/
void BFSReg(unsigned short int wAddress, unsigned short int wBitMask) {
        // SPI mode
        {
            unsigned char vBank;

            // See if we need to change register banks
            vBank = ((unsigned char) wAddress) & 0xE0;
            if (vBank != vCurrentBank) {
                if (vBank == (0x0u << 5))
                    Execute0(B0SEL);
                else if (vBank == (0x1u << 5))
                    Execute0(B1SEL);
                else if (vBank == (0x2u << 5))
                    Execute0(B2SEL);
                else if (vBank == (0x3u << 5))
                    Execute0(B3SEL);

                vCurrentBank = vBank;
            }

            Execute2(BFS | (wAddress & 0x1F), wBitMask);
        }
    } //end BFSReg

void BFCReg(unsigned short int wAddress, unsigned short int wBitMask) {
        // SPI mode
        {
            unsigned char vBank;

            // See if we need to change register banks
            vBank = ((unsigned char) wAddress) & 0xE0;
            if (vBank != vCurrentBank) {
                if (vBank == (0x0u << 5))
                    Execute0(B0SEL);
                else if (vBank == (0x1u << 5))
                    Execute0(B1SEL);
                else if (vBank == (0x2u << 5))
                    Execute0(B2SEL);
                else if (vBank == (0x3u << 5))
                    Execute0(B3SEL);

                vCurrentBank = vBank;
            }

            Execute2(BFC | (wAddress & 0x1F), wBitMask);
        }
    }
    //end BFCReg

/******************************************************************************
 * Function:        Execute0(unsigned char vOpcode)
 *
 * PreCondition:    SPI bus must be initialized (done in MACInit()).
 *
 * Input:           None
 *
 * Output:          None
 *
 * Side Effects:    None
 *
 * Overview:        Sends a single unsigned char command with no parameters
 *
 * Note:            None
 *****************************************************************************/
void Execute0(unsigned char vOpcode) {
        volatile unsigned char vDummy;

        AssertChipSelect();
        ClearSPIDoneFlag();
        SSPBUF = vOpcode; // Send the command/opcode
        WaitForDatabyte();
        vDummy = SSPBUF;
        DeassertChipSelect();


    } //end Execute0

unsigned Execute2(unsigned char vOpcode, unsigned wData) {
        volatile unsigned wReturn;

        AssertChipSelect();
        ClearSPIDoneFlag();
        SSPBUF = vOpcode; // Send the command/opcode
        WaitForDatabyte();
        ((unsigned char * ) & wReturn)[0] = SSPBUF;
        SSPBUF = ((unsigned char * ) & wData)[0]; // Send low unsigned char of data
        WaitForDatabyte();
        ((unsigned char * ) & wReturn)[0] = SSPBUF;
        SSPBUF = ((unsigned char * ) & wData)[1]; // Send high unsigned char of data
        WaitForDatabyte();
        ((unsigned char * ) & wReturn)[1] = SSPBUF;
        DeassertChipSelect();
        return wReturn;
    } //end Execute2

unsigned long Execute3(unsigned char vOpcode, unsigned long dwData) {
        unsigned long dwReturn;

        AssertChipSelect();
        ClearSPIDoneFlag();
        SSPBUF = vOpcode; // Send the command/opcode
        ((unsigned char * ) & dwReturn)[3] = 0x00;
        WaitForDatabyte();
        ((unsigned char * ) & dwReturn)[0] = SSPBUF;
        SSPBUF = ((unsigned char * ) & dwData)[0]; // Send unsigned char 0 of data
        WaitForDatabyte();
        ((unsigned char * ) & dwReturn)[0] = SSPBUF;
        SSPBUF = ((unsigned char * ) & dwData)[1]; // Send unsigned char 1 of data
        WaitForDatabyte();
        ((unsigned char * ) & dwReturn)[1] = SSPBUF;
        SSPBUF = ((unsigned char * ) & dwData)[2]; // Send unsigned char 2 of data
        WaitForDatabyte();
        ((unsigned char * ) & dwReturn)[2] = SSPBUF;
        DeassertChipSelect();

        return dwReturn;
    } //end Execute2


// A function potentially useful for debugging, but a waste of code otherwise
void WriteReg_Hex(unsigned char * kommandoTekst, unsigned char Register) {
    strcpy(buffer, kommandoTekst);
    WordtoHex(ReadReg(Register), HexStr);
    strcat(buffer, HexStr);
    UART1_Write_Text(buffer);
}

void ENC100DumpState(void) {
    strcpy(buffer, "\r\n  Next Packet Pointer    = 0x");
    WordtoHex(NextPacketPointer, HexStr);
    strcat(buffer, HexStr);
    UART1_Write_Text(buffer);
    UART1_Write_Text("\r\n");
    WriteReg_Hex("\r\n EIR     = 0x", EIR);

    WriteReg_Hex("\r\n ERXST   = 0x", ERXST);
    WriteReg_Hex("\r\n ERXRDPT = 0x", ERXRDPT);
    WriteReg_Hex("\r\n ERXWRPT = 0x", ERXWRPT);
    WriteReg_Hex("\r\n ERXTAIL = 0x", ERXTAIL);
    WriteReg_Hex("\r\n ERXHEAD = 0x", ERXHEAD);
    WriteReg_Hex("\r\n ESTAT   = 0x", ESTAT);
    WriteReg_Hex("\r\n ERXFCON = 0x", ERXFCON);
    WriteReg_Hex("\r\n MACON1  = 0x", MACON1);
    WriteReg_Hex("\r\n MACON2  = 0x", MACON2);
    WriteReg_Hex("\r\n ECON1   = 0x", ECON1);
    WriteReg_Hex("\r\n ECON2   = 0x", ECON2);
    WriteReg_Hex("\r\n ETXST   = 0x", ETXST);
    WriteReg_Hex("\r\n ETXLEN  = 0x", ETXLEN);
    WriteReg_Hex("\r\n EDMAST  = 0x", EDMAST);
    WriteReg_Hex("\r\n EDMALEN = 0x", EDMALEN);
    WriteReg_Hex("\r\n EDMADST = 0x", EDMADST);
    WriteReg_Hex("\r\n EDMACS  = 0x", EDMACS);
    WriteReg_Hex("\r\n MAADR3  = 0x", MAADR3);
    WriteReg_Hex("\r\n MAADR2  = 0x", MAADR2);
    WriteReg_Hex("\r\n MAADR1  = 0x", MAADR1);

    UART1_Write_Text("\r\n");
}

void ShowPacket(unsigned short * Buffer, unsigned len) {
    char tal[3];
    unsigned PacI, LinI;

    UART1_Write_Text("\r\n");
    LinI = 0x00;
    for (PacI = 0; PacI < len; ++PacI) {
        ByteToHex(Buffer[PacI], tal);
        UART1_Write_Text(tal);
        UART1_Write_Text(" ");
        if (++LinI == 0x10) {
            LinI = 0x00;
            UART1_Write_Text("\r\n");
        }
    }
    UART1_Write_Text("\n\r");
}

void ClrPacket() {
    unsigned Len;
    Len = 200;
    do {
        Packet[Len] = 0;
    } while (Len--);
}