#line 1 "C:/Users/Bjarke/Desktop/GraphControl-PoC/Src/Pic_Server/PIC_Client.c"
#line 1 "c:/users/bjarke/desktop/graphcontrol-poc/src/pic_server/pic_client.h"



typedef enum _BOOL { FALSE = 0, TRUE = 1 } BOOL;
#line 61 "c:/users/bjarke/desktop/graphcontrol-poc/src/pic_server/pic_client.h"
unsigned char myMacAddr[6];
unsigned char myIpAddr[4] = {192, 168, 5, 150 };
unsigned RegValue;
unsigned RegStat;
unsigned short Regs[4][32];

unsigned short PckHdr[8];
unsigned PckLen;
unsigned short Packet[300];
unsigned short PseudoPacket[50];

unsigned RxLen;
unsigned UdpLen;
unsigned TCPDataLen;
unsigned TCPLen;

unsigned long TCP_Seq_num;
unsigned long TCP_Ack_Num;

unsigned char vCurrentBank;
unsigned NextPacketPointer;

unsigned char buffer[60];
unsigned char HexStr[10];
unsigned char Server_banner[] = "\r\nMicroC PIC Server>";


sfr sbit SPI_Ethernet_CS_Direction at TRISC1_bit;
sfr sbit SPI_Ethernet_SCK_Direction at TRISC3_bit;
sfr sbit SPI_Ethernet_SDO_Direction at TRISC5_bit;
sfr sbit SPI_Ethernet_SDI_Direction at TRISC4_bit;
sfr sbit SPI_Ethernet_CS at LATC1_bit;


typedef struct
{
 unsigned short DestMac[6];
 unsigned short ScrMac[6];
 unsigned int Type;
}EthHdr;

typedef struct
{
 unsigned int HwType;
 unsigned int PrType;
 unsigned short HwLen;
 unsigned short PrLen;
 unsigned int OpCode;
 unsigned short SHwAddr[6];
 unsigned short SIpAddr[4];
 unsigned short THwAddr[6];
 unsigned short TIpAddr[4];
}ArpHdr;

typedef struct
{
 EthHdr eth;
 ArpHdr arp;
}ArpStruct, *PArpStruct;

typedef struct
{
 unsigned short Ver_Len;
 unsigned short Tos;
 unsigned int PktLen;
 unsigned int Id;
 unsigned int Offset;
 unsigned short Ttl;
 unsigned short Proto;
 unsigned int CkSum;
 unsigned short ScrAddr[4];
 unsigned short DestAddr[4];
}IpHdr;

typedef struct
{
 unsigned short Type;
 unsigned short Code;
 unsigned int CkSum;
 unsigned int Id;
 unsigned int SeqNum;
}IcmpHdr;

typedef struct
{
 EthHdr eth;
 IpHdr ip;
} IpStruct, *PIpStruct;

PIpStruct IpData;

typedef struct
{
 EthHdr eth;
 IpHdr ip;
 IcmpHdr icmp;
}IcmpStruct, *PIcmpStruct;

typedef struct
{
 unsigned int SrcPort;
 unsigned int DestPort;
 unsigned int Len;
 unsigned int CkSum;
} UdpHdr;

typedef struct
{
 EthHdr eth;
 IpHdr ip;
 UdpHdr udp;
 unsigned short uddata[56];
} UdpStruct, *PUdpStruct;

typedef struct
{
 unsigned short SrcIP[4];
 unsigned short DestIP[4];
 unsigned short Zero;
 unsigned short Proto;
 unsigned int DataLen;
} Pseudohdr, *PPseudoStruct;
#line 200 "c:/users/bjarke/desktop/graphcontrol-poc/src/pic_server/pic_client.h"
typedef struct
{
 unsigned SourcePort;
 unsigned DestPort;
 unsigned long SeqNumber;
 unsigned long AckNumber;

 struct
 {
 unsigned char Reserved3 : 4;
 unsigned char Val : 4;
 } DataOffset;

 union
 {
 struct
 {
 unsigned char flagFIN : 1;
 unsigned char flagSYN : 1;
 unsigned char flagRST : 1;
 unsigned char flagPSH : 1;
 unsigned char flagACK : 1;
 unsigned char flagURG : 1;
 unsigned char Reserved2 : 2;
 } bits;
 unsigned short byte;
 } Flags;

 unsigned Window;
 unsigned Checksum;
 unsigned UrgentPointer;
 } TcpHdr;

typedef struct
{
 EthHdr eth;
 IpHdr ip;
 TcpHdr tcp;
 unsigned short uddata[120];
} TcpStruct, *PTcpStruct;

PTcpStruct TcpData;

typedef struct
{
 unsigned int SrcIP[4];
 unsigned int DestIP[4];
 unsigned short Zero;
 unsigned short Proto;
 unsigned int TcpLen;
} TcpPseudoHdr, *PTcpPseudoStruct;

PTcpPseudoStruct TcpPseudoData;

union
{
 unsigned short ShortVal[2];
 unsigned int IntVal;
} IntToShort, *PIntToShort;

union
 {
 struct
 {
 unsigned char flagFIN : 1;
 unsigned char flagSYN : 1;
 unsigned char flagRST : 1;
 unsigned char flagPSH : 1;
 unsigned char flagACK : 1;
 unsigned char flagURG : 1;
 unsigned char Reserved2 : 2;
 } bits;
 unsigned short byte;
 }TCPFlags;

typedef struct RSV
{
 unsigned NextPtr;
 unsigned ByteCount;

 unsigned short PreviouslyIgnored:1;
 unsigned short RXDCPreviouslySeen:1;
 unsigned short CarrierPreviouslySeen:1;
 unsigned short CodeViolation:1;
 unsigned short CRCError:1;
 unsigned short LengthCheckError:1;
 unsigned short LengthOutOfRange:1;
 unsigned short ReceiveOk:1;
 unsigned short Multicast:1;
 unsigned short Broadcast:1;
 unsigned short DribbleNibble:1;
 unsigned short ControlFrame:1;
 unsigned short PauseControlFrame:1;
 unsigned short UnsupportedOpcode:1;
 unsigned short VLANType:1;
 unsigned short RuntMatch:1;

 unsigned short filler:1;
 unsigned short HashMatch:1;
 unsigned short MagicPacketMatch:1;
 unsigned short PatternMatch:1;
 unsigned short UnicastMatch:1;
 unsigned short BroadcastMatch:1;
 unsigned short MulticastMatch:1;
 unsigned short ZeroH:1;
 unsigned short Zero:8;

}RXStruct, *PRXStruct;

RXStruct *RXData;

PPseudoStruct PseudoData;


 char  HandleArpPackage(PArpStruct arpData);
void HandleUdpPackage(PUdpStruct udpData);
void HandleTcpPackage(PTcpStruct tcpData);
 char  IsThisDevice(unsigned short ipAddr[]);
void SendMessage(PTcpStruct TcpData);


void MACInit(void);
void SendSystemReset(void);
unsigned int Tcp_CheckSum(PPseudoStruct TcpPseudoData, PTcpStruct TcpData);
void Trans_TCP (PTcpStruct TcpData, unsigned short PckLen, unsigned TCPLen);
unsigned short Udp_Rec (PUdpStruct PUdpData, unsigned short PckLen);
unsigned int Udp_CheckSum(PPseudoStruct UdpPseudoData, PUdpStruct UdpData);
void Udp_Trans(PUdpStruct PUdpData, unsigned short PckLen);
void Icmp (PIcmpStruct PIcmpData, unsigned short PckLen);
void Arp(PArpStruct PArpData, unsigned short PckLen);
void UdPacket (unsigned short* Data, unsigned len);
void TxPacket(unsigned short* PkData, unsigned len, unsigned short TX);
void ChkLink(void);
unsigned long swapByteOrder(unsigned long ui);
void SwapAddr (PIpStruct IpData);
unsigned int CkSum (unsigned offset, unsigned Len, unsigned short Seed);
unsigned ReadReg(unsigned short int wAddress);
void ReadMemoryWindow(unsigned short vWindow, unsigned short *vData, unsigned wLength);
void ReadN(unsigned char vOpcode, unsigned char* vData, unsigned wDataLen);
unsigned ReadPHYReg(unsigned char Register);

void WriteReg(unsigned short int wAddress, unsigned wValue);
void WriteMemoryWindow(unsigned short vWindow, unsigned short *vData, unsigned wLength);
void WriteN(unsigned short vOpcode, unsigned short* vData, unsigned wDataLen);
void WritePHYReg(unsigned char Register, unsigned short int Data);

void BFSReg(unsigned short int wAddress, unsigned short int wBitMask);
void BFCReg(unsigned short int wAddress, unsigned short int wBitMask);

void Execute0(unsigned char vOpcode);
unsigned Execute2(unsigned char vOpcode, unsigned wData);
unsigned long Execute3(unsigned char vOpcode, unsigned long dwData);

unsigned ChkPck(void);
unsigned GetFrame();
void WriteReg_Hex (unsigned char* kommandoTekst, unsigned char Register);
void ENC100DumpState(void);
void ShowPacket(unsigned short* Buffer, unsigned len);

void ClrPacket();
#line 1 "e:/mikroelektronika 2015/mikroc pro for pic/include/built_in.h"
#line 4 "C:/Users/Bjarke/Desktop/GraphControl-PoC/Src/Pic_Server/PIC_Client.c"
unsigned int adc_rd = 0;
PTcpStruct targetPacket;
unsigned int destinationPort = 0;
unsigned char destinationIp[4];
unsigned char destinationMac[6];
unsigned long seqNumber = 0;
unsigned long ackNumber = 0;

void main() {
 PArpStruct arpData;
 PIpStruct ipData;
 char buffer[50];
 int i = 0, lessThan = 0, moreThan = 0, oldadc_rd = 0;

 ANSELA = 0x02;
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
 adc_rd = ADC_Read(1);

 lessThan = oldadc_rd -  10; ;
 moreThan = oldadc_rd +  10; ;

 if (ChkPck()) {

 arpData = (PArpStruct) Packet;
 if (arpData->eth.Type == 0x0608)
 {
 if (!HandleArpPackage(arpData))
 {
 UART1_Write_Text("Ukendt device");
 }
 }

 else if (arpData->eth.Type == 0x0008)
 {
 ipData = (PIpStruct) Packet;
 if (IsThisDevice(ipData->Ip.DestAddr)) {
 switch (ipData->Ip.Proto)
 {
 case  1 :
 Icmp((PIcmpStruct) Packet, PckLen);
 break;
 case  17 :
 HandleUdpPackage((PUdpStruct) Packet);
 break;
 case  6 :
 HandleTcpPackage((PTcpStruct) Packet);
 break;
 }
 }
 }
 }
 else if (destinationPort != 0 && (lessThan > adc_rd || moreThan < adc_rd))
 {
 oldadc_rd = adc_rd;
 UART1_Write_Text("\n\rStart sending packet!\n\r");
 TcpData = (PTcpStruct)Packet;
 SendMessage((PTcpStruct) TcpData);
 UART1_Write_Text("\n\rFinished sending packet!\n\r");
 }
 } while ( 1 );
}

char* PrintIpAddr(unsigned short address[4])
{
 char buffer[50];
 sprintf(buffer, "%d . %d . %d . %d\0", (int)address[0], (int)address[1], (int)address[2], (int)address[3]);
 return buffer;
}

char* PrintMacAddr(unsigned short address[6])
{
 char buffer[50];
 sprintf(buffer, "%x : %x : %x : %x : %x : %x\0",
 (int)address[0], (int)address[1], (int)address[2], (int)address[3], (int)address[4], (int)address[5]);
 return buffer;
}

void PrintTcpPacket(PTcpStruct TcpData)
{
 char buffer[50];

 sprintf(buffer, "\n\rSource IP: %s", PrintIpAddr(TcpData->ip.ScrAddr));
 UART1_Write_Text(buffer);

 sprintf(buffer, "\n\rDest IP: %s", PrintIpAddr(TcpData->ip.DestAddr));
 UART1_Write_Text(buffer);

 sprintf(buffer, "\n\rSource Mac: %s", PrintMacAddr(TcpData->eth.ScrMac));
 UART1_Write_Text(buffer);

 sprintf(buffer, "\n\rDest Mac: %s", PrintMacAddr(TcpData->eth.DestMac));
 UART1_Write_Text(buffer);
}

void SendMessage(PTcpStruct TcpData) {
 unsigned IpTotLen, TcpTotLen, TxtLen, TcpDataLen;
 unsigned short i;

 IntToShort.IntVal = adc_rd;

 TcpData->tcp.Flags.byte = 0;

 UART1_Write_Text("\n\rProto is PSHACK");
 TcpDataLen = sizeof(int);

 TcpData->uddata[0] = IntToShort.ShortVal[0];
 TcpData->uddata[1] = IntToShort.ShortVal[1];
 TcpData->uddata[2] = 0x00;
 TxtLen = 2;

 TcpData->tcp.SeqNumber = SwapByteOrder(seqNumber);
 TcpData->tcp.AckNumber = SwapByteOrder(ackNumber);
 TcpData->tcp.Flags.bits.flagPSH = 1;
 TcpData->tcp.Flags.bits.flagACK = 1;

 TcpData->tcp.Window = 0x0004;
 TcpData->tcp.DataOffset.Reserved3 = 0x00;
 TcpData->tcp.DataOffset.Val = 0x05;

 TcpLen = sizeof(TcpHdr) + TxtLen;

 TcpData->tcp.Checksum = 0;
 TcpData->tcp.UrgentPointer = 0x00;

 TcpData->tcp.SourcePort = 0x8D13;
 TcpData->tcp.DestPort = destinationPort;

 IpTotLen = sizeof(IpHdr) + TcpLen;

 TcpData->ip.Proto =  6 ;
 TcpData->ip.Ver_Len = 0x45;
 TcpData->ip.Tos = 0x00;
 TcpData->ip.PktLen =  ((IpTotLen >> 8) | (IpTotLen <<8)) ;
 TcpData->ip.Id = 0x287;
 TcpData->ip.Offset = 0x0000;
 TcpData->ip.Ttl = 128;

 TcpData->eth.Type = 0x0008;


 memcpy(TcpData->ip.ScrAddr, destinationIp, 4);
 memcpy(TcpData->ip.DestAddr, MyIpAddr, 4);

 memcpy(TcpData->eth.DestMac, MyMacAddr, 6);
 memcpy(TcpData->eth.ScrMac, destinationMac, 6);

 PseudoData = (PPseudoStruct) PseudoPacket;

 Tcp_CheckSum((PPseudoStruct) PseudoData, (PTcpStruct) TcpData);

 PrintTcpPacket(TcpData);

 Trans_TCP ((PTcpStruct) TcpData, PckLen, TCPLen);
}

 char  HandleArpPackage(PArpStruct arpData) {
 UART1_Write_Text("\n\rARP Pakke. ");
 if (arpData->arp.HwType == 0x0100 &&
 arpData->arp.PrType == 0x0008 &&
 arpData->arp.HwLen == 0x06 && arpData->arp.PrLen == 0x04 &&
 arpData->arp.OpCode == 0x0100 &&
 IsThisDevice(arpData->arp.TIpAddr)) {
 Arp((PArpStruct) arpData, PckLen);
 return  1 ;
 }
 else{
 return  0 ;
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
 if (tcpData->tcp.DestPort == 0x8D13)
 {
 UART1_Write_Text("TCP Pakke modtaget port 5005\n\r");

 tcpData = (PTcpStruct) Packet;

 seqNumber = SwapByteOrder(tcpData->tcp.AckNumber);
 ackNumber = SwapByteOrder(tcpData->tcp.SeqNumber);

 pseudoData = (PPseudoStruct) PseudoPacket;
 Tcp_CheckSum((PPseudoStruct) pseudoData, (PTcpStruct) tcpData);

 TCPFlags.byte = tcpData->tcp.Flags.byte;
 tcpData->tcp.Flags.byte = 0;

 if (TCPFlags.byte ==  (0x02) ) {
 UART1_Write_Text("TCP SYN Pakke modtaget\n\r");
 TCP_Ack_Num = tcpData->tcp.SeqNumber;
 TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
 TCP_Ack_Num++;
 TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
 tcpData->tcp.AckNumber = TCP_Ack_Num;

 tcpData->tcp.SeqNumber = 0x78563412;

 tcpData->tcp.Flags.bits.flagSYN = 1;
 tcpData->tcp.Flags.bits.flagACK = 1;

 TCPLen = tcpData->tcp.DataOffset.Val * 4;
 Trans_TCP((PTcpStruct) tcpData, PckLen, TCPLen);

 UART1_Write_Text("TCP SYN Pakke sendt\n\r");
 } else if (TCPFlags.byte ==  (0x18) ) {
 unsigned short i;
 unsigned DataLen;
 UART1_Write_Text("TCP ACK DataPakke modtaget\n\r");

 DataLen =  (((tcpData->ip.PktLen) >> 8) | ((tcpData->ip.PktLen) <<8)) ;
 TCPDataLen = DataLen - ((tcpData->tcp.DataOffset.Val * 4) + 20);
 if (TCPDataLen) {
 TCP_Ack_Num = tcpData->tcp.SeqNumber;
 TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
 TCP_Ack_Num += TCPDataLen;
 TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);

 sprintf(buffer, "%d", seqNumber);
 UART1_Write_Text("\n\rAfter: ");
 UART1_Write_Text(buffer);
 UART1_Write_Text("\n\r");

 tcpData->tcp.SeqNumber = tcpData->tcp.AckNumber;
 tcpData->tcp.AckNumber = TCP_Ack_Num;

 tcpData->tcp.Flags.bits.flagACK = 1;

 UART1_Write_Text("\n\r");

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
 destinationPort = tcpData->tcp.DestPort;
 memcpy(destinationMac, tcpData->eth.DestMac, 6);
 memcpy(destinationIp, tcpData->ip.DestAddr, 4);

 sprintf(buffer, "\n\rDestination IP variable: %s", PrintIpAddr(destinationIp));
 UART1_Write_Text(buffer);
 sprintf(buffer, "\n\rDestination Mac variable: %s", PrintMacAddr(destinationMac));
 UART1_Write_Text(buffer);

 } else if (TCPFlags.byte ==  (0x11) ) {
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

 char  IsThisDevice(unsigned short ipAddr[])
{
 if (ipAddr[0] == MyIpAddr[0] &&
 ipAddr[1] == MyIpAddr[1] &&
 ipAddr[2] == MyIpAddr[2] &&
 ipAddr[3] == MyIpAddr[3])
 {
 return  1 ;
 }
 else
 {
 return  0 ;
 }
}

unsigned int Tcp_CheckSum(PPseudoStruct TcpPseudoData, PTcpStruct TcpData) {

 unsigned short i;
 unsigned DataLen, TcpCkSum;
 unsigned TcpDataLen, TcpHdrLen;

 DataLen =  ((TcpData->ip.PktLen >> 8) | (TcpData->ip.PktLen <<8)) ;
 TCPDataLen = DataLen - ((TcpData->tcp.DataOffset.Val * 4) + 20);

 TcpHdrLen = (TcpData->tcp.DataOffset.Val * 4) + TCPDataLen;

 for (i = 0; i <= 3; i++) {
 TcpPseudoData->SrcIP[i] = TcpData->ip.ScrAddr[i];
 TcpPseudoData->DestIP[i] = TcpData->ip.DestAddr[i];
 }
 TcpPseudoData->Zero = 0;
 TcpPseudoData->Proto =  6 ;
 TcpPseudoData->DataLen =  ((TcpHdrLen >> 8) | (TcpHdrLen <<8)) ;

 UdPacket((unsigned short * ) TcpPseudoData, 12);
 UART1_Write_Text("TCP pseudo Trans Pakke\n\r");

 TcpCkSum = Cksum( 0  + ( 1518  + 100) , 12, 0);


 return TcpCkSum;
}


void Trans_TCP(PTcpStruct TcpData, unsigned short PckLen, unsigned TCPLen) {
 unsigned int temp;

 SwapAddr((PIpStruct) TcpData);

 temp = TcpData->Tcp.SourcePort;
 TcpData->tcp.SourcePort = TcpData->tcp.DestPort;
 TcpData->tcp.DestPort = temp;

 TcpData->tcp.Checksum = 0;

 TxPacket((unsigned short * ) TcpData, PckLen, FALSE);

 TcpData->tcp.Checksum = CkSum(sizeof(IpStruct), TCPLen, TRUE);;





 TxPacket((unsigned short * ) TcpData, PckLen, TRUE);
}

unsigned short Udp_Rec(PUdpStruct PUdpData, unsigned short PckLen) {
 unsigned short TekstLen;
 UART1_Write_Text("UDP Pakke modtaget\n\r");
 if (PUdpData->udp.DestPort == 0x8D13)
 {
 TekstLen = SWAP(PUdpData->udp.Len) - 8;
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
 UdpPseudoData->Proto = 17;
 UdpPseudoData->DataLen = UdpData->udp.Len;
 UdPacket((unsigned short * ) UdpPseudoData, 12);
 UART1_Write_Text("UDP pseudo Trans Pakke\n\r");

 CheckSum = Cksum( 0  + ( 1518  + 100) , 12, 0);

 WordToStr(Checksum, HexStr);
 UART1_Write_Text("\n\rPseudo Checksum  :");
 UART1_Write_Text(HexStr);
 UART1_Write_Text("\n\r");


 return CheckSum;
}


void Udp_Trans(PUdpStruct PUdpData, unsigned short PckLen) {

 unsigned int temp;
 unsigned short TekstLen, i;

 UART1_Write_Text("UDP Trans Pakke\n\r");
 UdpLen =  ((PUdpData->udp.Len >> 8) | (PUdpData->udp.Len <<8)) ;
 TekstLen = UdpLen - 8;
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

 TxPacket((unsigned short * ) PUdpData, PckLen, FALSE);

 PUdpData->udp.CkSum = Cksum(sizeof(IpStruct), UdpLen, 1);
 ShowPacket((unsigned short * ) PUdpData, PckLen);
 TxPacket((unsigned short * ) PUdpData, PckLen, TRUE);
}

void Icmp(PIcmpStruct PIcmpData, unsigned short PckLen) {
 unsigned int len;
 PIcmpData->icmp.Type = 0x00;
 PIcmpData->icmp.Code = 0x00;
 PIcmpData->icmp.CkSum = 0x0000;
 PIcmpData->ip.CkSum = 0x0000;
 SwapAddr((PIpStruct) PIcmpData);
 TxPacket((unsigned short * ) PIcmpData, PckLen, 0);

 PIcmpData->ip.CkSum = CkSum(sizeof(EthHdr), sizeof(IpHdr), 0);

 len = SWAP(PIcmpData->ip.PktLen);
 PIcmpData->icmp.CkSum = CkSum(sizeof(IpStruct), PckLen - sizeof(IpStruct), 0);
 TxPacket((unsigned short * ) PIcmpData, PckLen, 1);
}

void Arp(PArpStruct PArpData, unsigned short PckLen) {
 unsigned short i;
 unsigned Len;

 PArpData->arp.OpCode =  ((0x0002 >> 8) | (0x0002 <<8)) ;
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
 WriteReg( (0x90u) ,  0  + ( 1518  + 100) );
 WriteReg( (0x8Eu) ,  0  + ( 1518  + 100) );
 WriteMemoryWindow( (0x1) , Data, len);

}

void TxPacket(unsigned short * PkData, unsigned len, unsigned short TX) {
 unsigned read;
 do {
 read = ReadReg( (0x1Eu) );
 } while (Read &  (1<<1) );
 WriteReg( (0x8Cu) ,  0 );
 WriteMemoryWindow( (0x4) , PkData, len);
 if (TX) {
 WriteReg( (0x00u) , (unsigned) 0x0000);
 WriteReg( (0x02u) , len);
 do {
 read = ReadReg( (0x1Eu) );
 } while (Read &  (1<<1) );

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
 Read = ReadReg( (0x1Eu) );
 } while (Read &  (1<<5) );

 BFCREG( (0x1Eu) ,  (1<<4) );
 BFCREG( (0x1Eu) ,  (1<<2) );
 if (Seed)
 BFSREG( (0x1Eu) ,  (1<<3) );
 else
 BFCREG( (0x1Eu) ,  (1<<3) );

 WriteReg( (0x0Au) ,  0  + offset);
 WriteReg( (0x0Cu) , Len);

 BFSREG( (0x1Eu) ,  (1<<5) );
 do {
 read = ReadReg( (0x1Eu) );
 } while (Read &  (1<<5) );

 read = (ReadReg( (0x10u) ));
 return read;
}
#line 568 "C:/Users/Bjarke/Desktop/GraphControl-PoC/Src/Pic_Server/PIC_Client.c"
void MACInit(void) {


  do{SPI_Ethernet_CS = 1;}while(0) ;

  do{SPI_Ethernet_CS_Direction = 0;SPI_Ethernet_SDO_Direction = 0;SPI_Ethernet_SCK_Direction = 0;SPI_Ethernet_SDI_Direction = 1; (SSP1CON1)  = 0; (SSP1STAT)  = 0x40; (SSP1CON1)  = 0x00  | 0x20; }while(0) ;
  do{ (PIR1.SSPIF)  = 0;}while(0) ;



 SendSystemReset();

 RegValue = ReadReg( (0x64u) );
 myMacAddr[0] =  (RegValue & 0xFF) ;
 myMacAddr[1] =  ((RegValue>>8) & 0xFF) ;
 RegValue = ReadReg( (0x62u) );
 myMacAddr[2] =  (RegValue & 0xFF) ;
 myMacAddr[3] =  ((RegValue>>8) & 0xFF) ;
 RegValue = ReadReg( (0x60u) );
 myMacAddr[4] =  (RegValue & 0xFF) ;
 myMacAddr[5] =  ((RegValue>>8) & 0xFF) ;



 NextPacketPointer =  0x5340 ;
 WriteReg( (0x00u) ,  0 );
 WriteReg( (0x04u) ,  0x5340 );
 WriteReg( (0x8Au) ,  0x5340 );
 WriteReg( (0x06u) ,  0x5FFF  - 2);




 WritePHYReg( 0x04u ,  ((unsigned short int)1<<10)  |  (1<<6)  |  (1<<5)  |  ((unsigned short int)1<<8)  |  (1<<7)  |  (1) );


 EXECUTE0( (0xE8u) );
 }

unsigned ChkPck() {
 unsigned short PckCnt;

 RegValue = ReadReg( (0x1Cu) );
 if (!(RegValue &  (1<<6) ))
 {
 return 0;
 }

 RegValue = ReadReg( (0x1Au) );
 PckCnt =  (RegValue & 0xFF) ;
 if (PckCnt) {
 PckLen = GetFrame();
 return PckLen;
 }
 return 0;
}

unsigned GetFrame() {
 unsigned RxLen;
 unsigned short PckHdr[8];

 WriteReg( (0x8Au) , NextPacketPointer);

 ReadMemoryWindow( (0x4) , PckHdr, 8);
 RXData = (PRXStruct) PckHdr;

 NextPacketPointer = RXData->NextPtr;
 RxLen = RXData->ByteCount;
 if (RxLen > 200) Rxlen = 200;

 ReadMemoryWindow( (0x4) , packet, RxLen);

 WriteReg( (0x06u) , RXData->NextPtr - 2);

 RxLen -= 4;
 Execute0( (0xCCu) );

 if (RXData->ReceiveOk) return (RxLen);
 else return 0;
}
#line 671 "C:/Users/Bjarke/Desktop/GraphControl-PoC/Src/Pic_Server/PIC_Client.c"
void ChkLink(void) {
 unsigned w;






 if (ReadReg( (0x1Cu) ) &  ((unsigned short int)1<<11) ) {
 BFCReg( (0x1Cu) ,  ((unsigned short int)1<<11) );


 w = ReadReg( (0x42u) );
 if (ReadReg( (0x1Au) ) &  ((unsigned short int)1<<10) ) {

 WriteReg( (0x44u) , 0x15);
 w |=  (1) ;
 } else {

 WriteReg( (0x44u) , 0x12);
 w &= ~ (1) ;
 }
 WriteReg( (0x42u) , w);
 }










 do {
 RegValue = ReadReg( (0x1Au) );
 } while (!(RegValue &  ((unsigned short int)1<<8) ));

 EXECUTE0( (0xD4u) );

 do {
 RegValue = ReadReg( (0x1Eu) );
 } while (RegValue &  (1<<1) );
}
#line 750 "C:/Users/Bjarke/Desktop/GraphControl-PoC/Src/Pic_Server/PIC_Client.c"
void SendSystemReset(void) {

 do {






 do {
 WriteReg( (0x16u) , 0x1234);
 } while (ReadReg( (0x16u) ) != 0x1234u);


 Execute0( (0xCAu) );
 vCurrentBank = 0;
 while ((ReadReg( (0x1Au) ) & ( ((unsigned short int)1<<12)  |  ((unsigned short int)1<<11)  |  ((unsigned short int)1<<9) )) != ( ((unsigned short int)1<<12)  |  ((unsigned short int)1<<11)  |  ((unsigned short int)1<<9) ));
 Delay_us(30);






 } while (ReadReg( (0x16u) ) != 0x0000u);


 Delay_Ms(1);

 }
#line 799 "C:/Users/Bjarke/Desktop/GraphControl-PoC/Src/Pic_Server/PIC_Client.c"
unsigned ReadReg(unsigned short int wAddress) {

 {
 unsigned w;
 unsigned char vBank;


 vBank = ((unsigned char) wAddress) & 0xE0;
 if (vBank <= (0x3u << 5)) {
 if (vBank != vCurrentBank) {
 if (vBank == (0x0u << 5))
 Execute0( (0xC0u) );
 else if (vBank == (0x1u << 5))
 Execute0( (0xC2u) );
 else if (vBank == (0x2u << 5))
 Execute0( (0xC4u) );
 else if (vBank == (0x3u << 5))
 Execute0( (0xC6u) );

 vCurrentBank = vBank;
 }

 w = Execute2( (0x0u<<5)  | (wAddress & 0x1F), 0x0000);
 } else {
 unsigned long dw = Execute3( (0x20u) , (unsigned short int) wAddress);
 ((unsigned char * ) & w)[0] = ((unsigned char * ) & dw)[1];
 ((unsigned char * ) & w)[1] = ((unsigned char * ) & dw)[2];
 }

 return w;
 }
 }
#line 856 "C:/Users/Bjarke/Desktop/GraphControl-PoC/Src/Pic_Server/PIC_Client.c"
void ReadMemoryWindow(unsigned short vWindow, unsigned short * vData, unsigned wLength) {
 unsigned short vOpcode;

 vOpcode =  (0x30u) ;
 if (vWindow ==  (0x2) )
 vOpcode =  (0x28u) ;
 if (vWindow ==  (0x4) )
 vOpcode =  (0x2Cu) ;

 ReadN(vOpcode, vData, wLength);
}

void ReadN(unsigned char vOpcode, unsigned char * vData, unsigned wDataLen) {
 volatile unsigned char vDummy;

  do{SPI_Ethernet_CS = 0;}while(0) ;
  do{ (PIR1.SSPIF)  = 0;}while(0) ;
  (SSP1BUF)  = vOpcode;
  do{while(! (PIR1.SSPIF) ); (PIR1.SSPIF)  = 0;}while(0) ;
 vDummy =  (SSP1BUF) ;
 while (wDataLen--) {
  (SSP1BUF)  = 0x00;
  do{while(! (PIR1.SSPIF) ); (PIR1.SSPIF)  = 0;}while(0) ; * vData =  (SSP1BUF) ;
 vData++;
 }
  do{SPI_Ethernet_CS = 1;}while(0) ;


}
#line 903 "C:/Users/Bjarke/Desktop/GraphControl-PoC/Src/Pic_Server/PIC_Client.c"
unsigned ReadPHYReg(unsigned char Register) {
 unsigned wResult;


 WriteReg( (0x54u) , 0x0100 | Register);
 WriteReg( (0x52u) ,  (1) );



 while (ReadReg( (0x6Au) ) &  (1) );


 WriteReg( (0x52u) , 0x0000);


 wResult = ReadReg( (0x68u) );

 return wResult;
 }
#line 941 "C:/Users/Bjarke/Desktop/GraphControl-PoC/Src/Pic_Server/PIC_Client.c"
void WriteReg(unsigned short int wAddress, unsigned wValue) {

 {
 unsigned char vBank;


 vBank = ((unsigned char) wAddress) & 0xE0;
 if (vBank <= (0x3u << 5)) {
 if (vBank != vCurrentBank) {
 if (vBank == (0x0u << 5))
 Execute0( (0xC0u) );
 else if (vBank == (0x1u << 5))
 Execute0( (0xC2u) );
 else if (vBank == (0x2u << 5))
 Execute0( (0xC4u) );
 else if (vBank == (0x3u << 5))
 Execute0( (0xC6u) );

 vCurrentBank = vBank;
 }

 Execute2( (0x2u<<5)  | (wAddress & 0x1F), wValue);
 } else {
 unsigned long dw;
 ((unsigned char * ) & dw)[0] = (unsigned char) wAddress;
 ((unsigned char * ) & dw)[1] = ((unsigned char * ) & wValue)[0];
 ((unsigned char * ) & dw)[2] = ((unsigned char * ) & wValue)[1];
 Execute3( (0x22u) , dw);
 }

 }
 }
#line 996 "C:/Users/Bjarke/Desktop/GraphControl-PoC/Src/Pic_Server/PIC_Client.c"
void WriteMemoryWindow(unsigned short vWindow, unsigned short * vData, unsigned wLength) {
 unsigned short vOpcode;

 vOpcode =  (0x32u) ;
 if (vWindow &  (0x2) )
 vOpcode =  (0x2Au) ;
 if (vWindow &  (0x4) )
 vOpcode =  (0x2Eu) ;

 WriteN(vOpcode, vData, wLength);
}

void WriteN(unsigned char vOpcode, unsigned short * vData, unsigned wDataLen) {
 volatile unsigned char vDummy;

  do{SPI_Ethernet_CS = 0;}while(0) ;
  do{ (PIR1.SSPIF)  = 0;}while(0) ;
  (SSP1BUF)  = vOpcode;
  do{while(! (PIR1.SSPIF) ); (PIR1.SSPIF)  = 0;}while(0) ;
 vDummy =  (SSP1BUF) ;

 while (wDataLen--) {
  (SSP1BUF)  = * vData++;
  do{while(! (PIR1.SSPIF) ); (PIR1.SSPIF)  = 0;}while(0) ;
 vDummy =  (SSP1BUF) ;
 }
  do{SPI_Ethernet_CS = 1;}while(0) ;

}
#line 1044 "C:/Users/Bjarke/Desktop/GraphControl-PoC/Src/Pic_Server/PIC_Client.c"
void WritePHYReg(unsigned char Register, unsigned short int Data) {

 WriteReg( (0x54u) , 0x0100 | Register);


 WriteReg( (0x66u) , Data);


 while (ReadReg( (0x6Au) ) &  (1) );
 }
#line 1072 "C:/Users/Bjarke/Desktop/GraphControl-PoC/Src/Pic_Server/PIC_Client.c"
void BFSReg(unsigned short int wAddress, unsigned short int wBitMask) {

 {
 unsigned char vBank;


 vBank = ((unsigned char) wAddress) & 0xE0;
 if (vBank != vCurrentBank) {
 if (vBank == (0x0u << 5))
 Execute0( (0xC0u) );
 else if (vBank == (0x1u << 5))
 Execute0( (0xC2u) );
 else if (vBank == (0x2u << 5))
 Execute0( (0xC4u) );
 else if (vBank == (0x3u << 5))
 Execute0( (0xC6u) );

 vCurrentBank = vBank;
 }

 Execute2( (0x4u<<5)  | (wAddress & 0x1F), wBitMask);
 }
 }

void BFCReg(unsigned short int wAddress, unsigned short int wBitMask) {

 {
 unsigned char vBank;


 vBank = ((unsigned char) wAddress) & 0xE0;
 if (vBank != vCurrentBank) {
 if (vBank == (0x0u << 5))
 Execute0( (0xC0u) );
 else if (vBank == (0x1u << 5))
 Execute0( (0xC2u) );
 else if (vBank == (0x2u << 5))
 Execute0( (0xC4u) );
 else if (vBank == (0x3u << 5))
 Execute0( (0xC6u) );

 vCurrentBank = vBank;
 }

 Execute2( (0x5u<<5)  | (wAddress & 0x1F), wBitMask);
 }
 }
#line 1136 "C:/Users/Bjarke/Desktop/GraphControl-PoC/Src/Pic_Server/PIC_Client.c"
void Execute0(unsigned char vOpcode) {
 volatile unsigned char vDummy;

  do{SPI_Ethernet_CS = 0;}while(0) ;
  do{ (PIR1.SSPIF)  = 0;}while(0) ;
  (SSP1BUF)  = vOpcode;
  do{while(! (PIR1.SSPIF) ); (PIR1.SSPIF)  = 0;}while(0) ;
 vDummy =  (SSP1BUF) ;
  do{SPI_Ethernet_CS = 1;}while(0) ;


 }

unsigned Execute2(unsigned char vOpcode, unsigned wData) {
 volatile unsigned wReturn;

  do{SPI_Ethernet_CS = 0;}while(0) ;
  do{ (PIR1.SSPIF)  = 0;}while(0) ;
  (SSP1BUF)  = vOpcode;
  do{while(! (PIR1.SSPIF) ); (PIR1.SSPIF)  = 0;}while(0) ;
 ((unsigned char * ) & wReturn)[0] =  (SSP1BUF) ;
  (SSP1BUF)  = ((unsigned char * ) & wData)[0];
  do{while(! (PIR1.SSPIF) ); (PIR1.SSPIF)  = 0;}while(0) ;
 ((unsigned char * ) & wReturn)[0] =  (SSP1BUF) ;
  (SSP1BUF)  = ((unsigned char * ) & wData)[1];
  do{while(! (PIR1.SSPIF) ); (PIR1.SSPIF)  = 0;}while(0) ;
 ((unsigned char * ) & wReturn)[1] =  (SSP1BUF) ;
  do{SPI_Ethernet_CS = 1;}while(0) ;
 return wReturn;
 }

unsigned long Execute3(unsigned char vOpcode, unsigned long dwData) {
 unsigned long dwReturn;

  do{SPI_Ethernet_CS = 0;}while(0) ;
  do{ (PIR1.SSPIF)  = 0;}while(0) ;
  (SSP1BUF)  = vOpcode;
 ((unsigned char * ) & dwReturn)[3] = 0x00;
  do{while(! (PIR1.SSPIF) ); (PIR1.SSPIF)  = 0;}while(0) ;
 ((unsigned char * ) & dwReturn)[0] =  (SSP1BUF) ;
  (SSP1BUF)  = ((unsigned char * ) & dwData)[0];
  do{while(! (PIR1.SSPIF) ); (PIR1.SSPIF)  = 0;}while(0) ;
 ((unsigned char * ) & dwReturn)[0] =  (SSP1BUF) ;
  (SSP1BUF)  = ((unsigned char * ) & dwData)[1];
  do{while(! (PIR1.SSPIF) ); (PIR1.SSPIF)  = 0;}while(0) ;
 ((unsigned char * ) & dwReturn)[1] =  (SSP1BUF) ;
  (SSP1BUF)  = ((unsigned char * ) & dwData)[2];
  do{while(! (PIR1.SSPIF) ); (PIR1.SSPIF)  = 0;}while(0) ;
 ((unsigned char * ) & dwReturn)[2] =  (SSP1BUF) ;
  do{SPI_Ethernet_CS = 1;}while(0) ;

 return dwReturn;
 }



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
 WriteReg_Hex("\r\n EIR     = 0x",  (0x1Cu) );

 WriteReg_Hex("\r\n ERXST   = 0x",  (0x04u) );
 WriteReg_Hex("\r\n ERXRDPT = 0x",  (0x8Au) );
 WriteReg_Hex("\r\n ERXWRPT = 0x",  (0x8Cu) );
 WriteReg_Hex("\r\n ERXTAIL = 0x",  (0x06u) );
 WriteReg_Hex("\r\n ERXHEAD = 0x",  (0x08u) );
 WriteReg_Hex("\r\n ESTAT   = 0x",  (0x1Au) );
 WriteReg_Hex("\r\n ERXFCON = 0x",  (0x34u) );
 WriteReg_Hex("\r\n MACON1  = 0x",  (0x40u) );
 WriteReg_Hex("\r\n MACON2  = 0x",  (0x42u) );
 WriteReg_Hex("\r\n ECON1   = 0x",  (0x1Eu) );
 WriteReg_Hex("\r\n ECON2   = 0x",  (0x6Eu) );
 WriteReg_Hex("\r\n ETXST   = 0x",  (0x00u) );
 WriteReg_Hex("\r\n ETXLEN  = 0x",  (0x02u) );
 WriteReg_Hex("\r\n EDMAST  = 0x",  (0x0Au) );
 WriteReg_Hex("\r\n EDMALEN = 0x",  (0x0Cu) );
 WriteReg_Hex("\r\n EDMADST = 0x",  (0x0Eu) );
 WriteReg_Hex("\r\n EDMACS  = 0x",  (0x10u) );
 WriteReg_Hex("\r\n MAADR3  = 0x",  (0x60u) );
 WriteReg_Hex("\r\n MAADR2  = 0x",  (0x62u) );
 WriteReg_Hex("\r\n MAADR1  = 0x",  (0x64u) );

 UART1_Write_Text("\r\n");
}

void ShowPacket(unsigned short* Buffer, unsigned len)
{
 char tal[3];
 unsigned PacI,LinI;

 UART1_Write_Text("\r\n");
 LinI = 0x00;
 for(PacI=0;PacI<len;++PacI)
 {
 ByteToHex(Buffer[PacI], tal);
 UART1_Write_Text(tal);
 UART1_Write_Text (" ");
 if(++LinI == 0x10)
 {
 LinI = 0x00;
 UART1_Write_Text("\r\n");
 }
 }
 UART1_Write_Text("\n\r");
}

void ClrPacket()
{
 unsigned Len;
 Len = 200;
 do
 {
 Packet[Len] = 0;
 } while (Len --);


}
