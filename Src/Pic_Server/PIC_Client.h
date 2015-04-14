#ifndef __ENCX24J600_H
#define __ENCX24J600_H

typedef enum _BOOL { FALSE = 0, TRUE = 1 } BOOL;

// Macros
#define LOW(a)      (a & 0xFF)
#define HIGH(a)     ((a>>8) & 0xFF)
#define MAKE16(h,l)  ((h<<8) | l)
#define _SWAP(VEND) ((VEND >> 8) | (VEND <<8))
#define AssertChipSelect()     do{SPI_Ethernet_CS = 0;}while(0)
#define DeassertChipSelect()   do{SPI_Ethernet_CS = 1;}while(0)
#define ClearSPIDoneFlag()     do{SPI_IF = 0;}while(0)
#define WaitForDatabyte()      do{while(!SPI_IF); SPI_IF = 0;}while(0)
#define OPTIMAL_PRESCALE       0x00                                      // Default to divide by 4 setting

#define ConfigureSPIModule()   do{SPI_Ethernet_CS_Direction = 0;SPI_Ethernet_SDO_Direction = 0;SPI_Ethernet_SCK_Direction = 0;SPI_Ethernet_SDI_Direction = 1;                                                                                                                                                                \
                               SPICON1 = 0;                              /* SSPEN = 0 */                                        \
                               SPISTAT = 0x40;                           /* CKE = 1 (transmit data on rising edge), SMP = 0 (sample at middle of output time) */ \
                               SPICON1 = OPTIMAL_PRESCALE | 0x20;        /* SSPEN = 1, set clock speed */\
                               }while(0)

// ENC memory allocation
#define BUF_SIZE        1518
#define RAMSIZE          0x6000                         // 24kB RAM available
#define TXSTART          0                              // transmit buffer start address
#define TX_LENGTH        (BUF_SIZE + 100)               // transmit buffer length
#define RXSTART          0x5340                         // receive buffer start address
#define RXEND            0x5FFF                         // receive buffer end address
#define RXSIZE           (0x5FFF-RECEIVE_START+1)       // receive buffer size
#define REPLY_START     (TRANSMIT_START)                // reply buffer starts after per packet control byte

#define UDASTART   TXSTART + TX_LENGTH            // User data start Buffer
#define UDAEND     UDASTART + 100                 // User data end Buffer

// Binary constant identifiers for ReadMemoryWindow() and WriteMemoryWindow()
#define UDA_WINDOW               (0x1)
#define GP_WINDOW                (0x2)
#define RX_WINDOW                (0x4)

//Protocol constant
#define PROTO_ICMP 1
#define PROTO_TCP  6
#define PROTO_UDP  17

//SPI CONST
#define SPI_ENABLE                    (ENC100_SPISTATbits.SPIEN)
#define SPI_IF                        (PIR1.SSPIF)
#define SSPBUF                        (SSP1BUF)
#define SPISTAT                       (SSP1STAT)
#define SPISTATbits                   (SSP1STATbits)
#define SPICON1                       (SSP1CON1)
#define SPICON1bits                   (SSP1CON1bits)
#define SPICON2                       (SSP1CON2)
#define bool char
#define true 1
#define false 0
#define FluxLimit 10;

//Var Assignment
unsigned char myMacAddr[6]; // my MAC address
unsigned char myIpAddr[4]  = {192, 168, 5, 150 };  // my IP addr
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

// ENC424J600/624J600 SPI pinout
sfr sbit SPI_Ethernet_CS_Direction  at TRISC1_bit;
sfr sbit SPI_Ethernet_SCK_Direction at TRISC3_bit;
sfr sbit SPI_Ethernet_SDO_Direction at TRISC5_bit;
sfr sbit SPI_Ethernet_SDI_Direction at TRISC4_bit;
sfr sbit SPI_Ethernet_CS  at LATC1_bit;  // for writing to output pin always use latch (PIC18 family)


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
  IpHdr  ip;
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
  unsigned short uddata[56]; // 96-40
} UdpStruct, *PUdpStruct;

typedef struct
{
  unsigned short SrcIP[4];
  unsigned short DestIP[4];
  unsigned short Zero;
  unsigned short Proto;
  unsigned int DataLen;
} Pseudohdr, *PPseudoStruct;


/****************************************************************************
  Section:
        TCP Header Data Types
  ***************************************************************************/

#define FIN     (0x01)                // FIN Flag as defined in RFC
#define SYN     (0x02)                // SYN Flag as defined in RFC
#define RST     (0x04)                // Reset Flag as defined in RFC
#define PSH     (0x08)                // Push Flag as defined in RFC
#define ACK     (0x10)                // Acknowledge Flag as defined in RFC
#define URG     (0x20)                // Urgent Flag as defined in RFC
#define PSHACK  (0x18)
#define FINACK  (0x11)

// TCP Header Data Structure
typedef struct
{
  unsigned SourcePort;                // Local port number
  unsigned DestPort;                  // Remote port number
  unsigned long SeqNumber;            // Local sequence number
  unsigned long AckNumber;            // Acknowledging remote sequence number

  struct
  {
          unsigned char Reserved3      : 4;
          unsigned char Val            : 4;
  } DataOffset;                       // Data offset flags nibble

  union
  {
          struct
          {
                  unsigned char flagFIN    : 1;
                  unsigned char flagSYN    : 1;
                  unsigned char flagRST    : 1;
                  unsigned char flagPSH    : 1;
                  unsigned char flagACK    : 1;
                  unsigned char flagURG    : 1;
                  unsigned char Reserved2  : 2;
          } bits;
          unsigned short byte;
  } Flags;                                // TCP Flags as defined in RFC

  unsigned    Window;                     // Local free RX buffer window
  unsigned    Checksum;                   // Data payload checksum
  unsigned    UrgentPointer;              // Urgent pointer
  } TcpHdr;
  
typedef struct
{
  EthHdr eth;
  IpHdr ip;
  TcpHdr tcp;
  unsigned short uddata[120];             // 200-80
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
                  unsigned char flagFIN    : 1;
                  unsigned char flagSYN    : 1;
                  unsigned char flagRST    : 1;
                  unsigned char flagPSH    : 1;
                  unsigned char flagACK    : 1;
                  unsigned char flagURG    : 1;
                  unsigned char Reserved2  : 2;
          } bits;
          unsigned short byte;
  }TCPFlags;                                // TCP Flags as defined in RFC

typedef struct RSV
{
      unsigned              NextPtr;
      unsigned              ByteCount;
      
      unsigned short        PreviouslyIgnored:1;
      unsigned short        RXDCPreviouslySeen:1;
      unsigned short        CarrierPreviouslySeen:1;
      unsigned short        CodeViolation:1;
      unsigned short        CRCError:1;
      unsigned short        LengthCheckError:1;
      unsigned short        LengthOutOfRange:1;
      unsigned short        ReceiveOk:1;
      unsigned short        Multicast:1;
      unsigned short        Broadcast:1;
      unsigned short        DribbleNibble:1;
      unsigned short        ControlFrame:1;
      unsigned short        PauseControlFrame:1;
      unsigned short        UnsupportedOpcode:1;
      unsigned short        VLANType:1;
      unsigned short        RuntMatch:1;

      unsigned short        filler:1;
      unsigned short        HashMatch:1;
      unsigned short        MagicPacketMatch:1;
      unsigned short        PatternMatch:1;
      unsigned short        UnicastMatch:1;
      unsigned short        BroadcastMatch:1;
      unsigned short        MulticastMatch:1;
      unsigned short        ZeroH:1;
      unsigned short        Zero:8;

}RXStruct, *PRXStruct;

RXStruct *RXData;

PPseudoStruct PseudoData;

// Custom funcs
bool HandleArpPackage(PArpStruct arpData);
void HandleUdpPackage(PUdpStruct udpData);
void HandleTcpPackage(PTcpStruct tcpData);
bool IsThisDevice(unsigned short ipAddr[]);
void SendMessage(PTcpStruct TcpData);

// Proto type
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

void WriteReg(unsigned short int wAddress, unsigned  wValue);
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


        ////////////////////////////////////////////////////
        // ENC424J600/624J600 SPI Opcodes                                  //
        ////////////////////////////////////////////////////
#define RCR             (0x0u<<5)      // Read Control Register
#define WCR             (0x2u<<5)      // Write Control Register
#define RCRU            (0x20u)        // Read Control Register Unbanked
#define WCRU            (0x22u)        // Write Control Register Unbanked
#define BFS             (0x4u<<5)      // Bit Field Set
#define BFSU            (0x24u)        // Bit Field Set Unbanked
#define BFC             (0x5u<<5)      // Bit Field Clear
#define BFCU            (0x26u)        // Bit Field Clear Unbanked
#define RBMGP           (0x28u)        // Read Buffer Memory General Purpose
#define WBMGP           (0x2Au)        // Write Buffer Memory General Purpose
#define RBMRX           (0x2Cu)        // Read Buffer Memory RX
#define WBMRX           (0x2Eu)        // Write Buffer Memory RX
#define RBMUDA          (0x30u)        // Read Buffer Memory User Defined Area
#define WBMUDA          (0x32u)        // Write Buffer Memory User Defined Area
#define WGPRDPT         (0x60u)        // Write General Purpose Read Pointer
#define RGPRDPT         (0x62u)        // Read General Purpose Read Pointer
#define WRXRDPT         (0x64u)        // Write RX Read Pointer
#define RRXRDPT         (0x66u)        // Read RX Read Pointer
#define WUDARDPT        (0x68u)        // Write User Defined Area Read Pointer
#define RUDARDPT        (0x6Au)        // Read User Defined Area Read Pointer
#define WGPWRPT         (0x6Cu)        // Write General Purpose Write Pointer
#define RGPWRPT         (0x6Eu)        // Read General Purpose Write Pointer
#define WRXWRPT         (0x70u)        // Write RX Write Pointer
#define RRXWRPT         (0x72u)        // Read RX Write Pointer
#define WUDAWRPT        (0x74u)        // Write User Defined Area Write Pointer
#define RUDAWRPT        (0x76u)        // Read User Defined Area Write Pointer
#define B0SEL           (0xC0u)        // Bank 0 Select
#define B1SEL           (0xC2u)        // Bank 1 Select
#define B2SEL           (0xC4u)        // Bank 2 Select
#define B3SEL           (0xC6u)        // Bank 3 Select
#define RBSEL           (0xC8u)        // Read Bank Select
#define SETETHRST       (0xCAu)        // Set ETHRST bit (perform system reset)
#define FCDIS           (0xE0u)        // Flow Control Disable
#define FCSINGLE        (0xE2u)        // Flow Control Single
#define FCMULTIPLE      (0xE4u)        // Flow Control Multiple
#define FCCLEAR         (0xE6u)        // Flow Control Clear
#define SETPKTDEC       (0xCCu)        // Set PKTDEC bit (decrement RX packet pending counter)
#define DMASTOP         (0xD0u)        // DMA Stop
#define DMACKSUM        (0xD8u)        // DMA Start Checksum
#define DMACKSUMS       (0xDAu)        // DMA Start Checksum with Seed
#define DMACOPY         (0xDCu)        // DMA Start Copy
#define DMACOPYS        (0xDEu)        // DMA Start Copy and Checksum with Seed
#define SETTXRTS        (0xD4u)        // Set TXRTS bit (transmit a packet)
#define ENABLERX        (0xE8u)        // Enable RX
#define DISABLERX       (0xEAu)        // Disable RX
#define SETEIE          (0xECu)        // Set Ethernet Interrupt Enable (EIE)
#define CLREIE          (0xEEu)        // Clear Ethernet Interrupt Enable (EIE)

 ////////////////////////////////////////////////////
// ENC424J600/624J600 register addresses                  //
////////////////////////////////////////////////////
// SPI Bank 0 registers --------
#define ETXST                (0x00u)
#define ETXSTL               (0x00u)
#define ETXSTH               (0x01u)
#define ETXLEN               (0x02u)
#define ETXLENL              (0x02u)
#define ETXLENH              (0x03u)
#define ERXST                (0x04u)
#define ERXSTL               (0x04u)
#define ERXSTH               (0x05u)
#define ERXTAIL              (0x06u)
#define ERXTAILL             (0x06u)
#define ERXTAILH             (0x07u)
#define ERXHEAD              (0x08u)
#define ERXHEADL             (0x08u)
#define ERXHEADH             (0x09u)
#define EDMAST               (0x0Au)
#define EDMASTL              (0x0Au)
#define EDMASTH              (0x0Bu)
#define EDMALEN              (0x0Cu)
#define EDMALENL             (0x0Cu)
#define EDMALENH             (0x0Du)
#define EDMADST              (0x0Eu)
#define EDMADSTL             (0x0Eu)
#define EDMADSTH             (0x0Fu)
#define EDMACS               (0x10u)
#define EDMACSL              (0x10u)
#define EDMACSH              (0x11u)
#define ETXSTAT              (0x12u)
#define ETXSTATL             (0x12u)
#define ETXSTATH             (0x13u)
#define ETXWIRE              (0x14u)
#define ETXWIREL             (0x14u)
#define ETXWIREH             (0x15u)

// SPI all bank registers
#define EUDAST               (0x16u)
#define EUDASTL              (0x16u)
#define EUDASTH              (0x17u)
#define EUDAND               (0x18u)
#define EUDANDL              (0x18u)
#define EUDANDH              (0x19u)
#define ESTAT                (0x1Au)
#define ESTATL               (0x1Au)
#define ESTATH               (0x1Bu)
#define EIR                  (0x1Cu)
#define EIRL                 (0x1Cu)
#define EIRH                 (0x1Du)
#define ECON1                (0x1Eu)
#define ECON1L               (0x1Eu)
#define ECON1H               (0x1Fu)


// SPI Bank 1 registers -----
#define EHT1                (0x20u)
#define EHT1L               (0x20u)
#define EHT1H               (0x21u)
#define EHT2                (0x22u)
#define EHT2L               (0x22u)
#define EHT2H               (0x23u)
#define EHT3                (0x24u)
#define EHT3L               (0x24u)
#define EHT3H               (0x25u)
#define EHT4                (0x26u)
#define EHT4L               (0x26u)
#define EHT4H               (0x27u)
#define EPMM1               (0x28u)
#define EPMM1L              (0x28u)
#define EPMM1H              (0x29u)
#define EPMM2               (0x2Au)
#define EPMM2L              (0x2Au)
#define EPMM2H              (0x2Bu)
#define EPMM3               (0x2Cu)
#define EPMM3L              (0x2Cu)
#define EPMM3H              (0x2Du)
#define EPMM4               (0x2Eu)
#define EPMM4L              (0x2Eu)
#define EPMM4H              (0x2Fu)
#define EPMCS               (0x30u)
#define EPMCSL              (0x30u)
#define EPMCSH              (0x31u)
#define EPMO                (0x32u)
#define EPMOL               (0x32u)
#define EPMOH               (0x33u)
#define ERXFCON             (0x34u)
#define ERXFCONL            (0x34u)
#define ERXFCONH            (0x35u)

// SPI all bank registers from 0x36 to 0x3F


// SPI Bank 2 registers -----
#define MACON1              (0x40u)
#define MACON1L             (0x40u)
#define MACON1H             (0x41u)
#define MACON2              (0x42u)
#define MACON2L             (0x42u)
#define MACON2H             (0x43u)
#define MABBIPG             (0x44u)
#define MABBIPGL            (0x44u)
#define MABBIPGH            (0x45u)
#define MAIPG               (0x46u)
#define MAIPGL              (0x46u)
#define MAIPGH              (0x47u)
#define MACLCON             (0x48u)
#define MACLCONL            (0x48u)
#define MACLCONH            (0x49u)
#define MAMXFL              (0x4Au)
#define MAMXFLL             (0x4Au)
#define MAMXFLH             (0x4Bu)
//#define r                    (0x4Cu)
//#define r                    (0x4Du)
//#define r                    (0x4Eu)
//#define r                    (0x4Fu)
//#define r                    (0x50u)
//#define r                    (0x51u)
#define MICMD               (0x52u)
#define MICMDL              (0x52u)
#define MICMDH              (0x53u)
#define MIREGADR            (0x54u)
#define MIREGADRL           (0x54u)
#define MIREGADRH           (0x55u)

// SPI all bank registers from 0x56 to 0x5F


// SPI Bank 3 registers -----
#define MAADR3                (0x60u)
#define MAADR3L               (0x60u)
#define MAADR3H               (0x61u)
#define MAADR2                (0x62u)
#define MAADR2L               (0x62u)
#define MAADR2H               (0x63u)
#define MAADR1                (0x64u)
#define MAADR1L               (0x64u)
#define MAADR1H               (0x65u)
#define MIWR                  (0x66u)
#define MIWRL                 (0x66u)
#define MIWRH                 (0x67u)
#define MIRD                  (0x68u)
#define MIRDL                 (0x68u)
#define MIRDH                 (0x69u)
#define MISTAT                (0x6Au)
#define MISTATL               (0x6Au)
#define MISTATH               (0x6Bu)
#define EPAUS                 (0x6Cu)
#define EPAUSL                (0x6Cu)
#define EPAUSH                (0x6Du)
#define ECON2                 (0x6Eu)
#define ECON2L                (0x6Eu)
#define ECON2H                (0x6Fu)
#define ERXWM                 (0x70u)
#define ERXWML                (0x70u)
#define ERXWMH                (0x71u)
#define EIE                   (0x72u)
#define EIEL                  (0x72u)
#define EIEH                  (0x73u)
#define EIDLED                (0x74u)
#define EIDLEDL               (0x74u)
#define EIDLEDH               (0x75u)

// SPI all bank registers from 0x66 to 0x6F


// SPI Non-banked Special Function Registers
#define EGPDATA              (0x80u)
#define EGPDATAL             (0x80u)
//#define r                     (0x81u)
#define ERXDATA              (0x82u)
#define ERXDATAL             (0x82u)
//#define r                     (0x83u)
#define EUDADATA             (0x84u)
#define EUDADATAL            (0x84u)
//#define r                     (0x85u)
#define EGPRDPT              (0x86u)
#define EGPRDPTL             (0x86u)
#define EGPRDPTH             (0x87u)
#define EGPWRPT              (0x88u)
#define EGPWRPTL             (0x88u)
#define EGPWRPTH             (0x89u)
#define ERXRDPT              (0x8Au)
#define ERXRDPTL             (0x8Au)
#define ERXRDPTH             (0x8Bu)
#define ERXWRPT              (0x8Cu)
#define ERXWRPTL             (0x8Cu)
#define ERXWRPTH             (0x8Du)
#define EUDARDPT             (0x8Eu)
#define EUDARDPTL            (0x8Eu)
#define EUDARDPTH            (0x8Fu)
#define EUDAWRPT             (0x90u)
#define EUDAWRPTL            (0x90u)
#define EUDAWRPTH            (0x91u)



////////////////////////////////////////////////////
// ENC424J600/624J600 PHY Register Addresses          //
////////////////////////////////////////////////////
#define PHCON1                0x00u
#define PHSTAT1               0x01u
#define PHANA                 0x04u
#define PHANLPA               0x05u
#define PHANE                 0x06u
#define PHCON2                0x11u
#define PHSTAT2               0x1Bu
#define PHSTAT3               0x1Fu



////////////////////////////////////////////////////
// ENC424J600/624J600 register bits                                  //
////////////////////////////////////////////////////
// ESTAT bits ----------
#define ESTAT_INT           ((unsigned short int)1<<15)
#define ESTAT_FCIDLE        ((unsigned short int)1<<14)
#define ESTAT_RXBUSY        ((unsigned short int)1<<13)
#define ESTAT_CLKRDY        ((unsigned short int)1<<12)
#define ESTAT_RSTDONE       ((unsigned short int)1<<11)
#define ESTAT_PHYDPX        ((unsigned short int)1<<10)
#define ESTAT_PHYRDY        ((unsigned short int)1<<9)
#define ESTAT_PHYLNK        ((unsigned short int)1<<8)
#define ESTAT_PKTCNT7        (1<<7)
#define ESTAT_PKTCNT6        (1<<6)
#define ESTAT_PKTCNT5        (1<<5)
#define ESTAT_PKTCNT4        (1<<4)
#define ESTAT_PKTCNT3        (1<<3)
#define ESTAT_PKTCNT2        (1<<2)
#define ESTAT_PKTCNT1        (1<<1)
#define ESTAT_PKTCNT0        (1)

// EIR bits ------------
#define EIR_CRYPTEN          ((unsigned short int)1<<15)
#define EIR_MODEXIF          ((unsigned short int)1<<14)
#define EIR_HASHIF           ((unsigned short int)1<<13)
#define EIR_AESIF            ((unsigned short int)1<<12)
#define EIR_LINKIF           ((unsigned short int)1<<11)
#define EIR_PRDYIF           ((unsigned short int)1<<10)
#define EIR_r9               ((unsigned short int)1<<9)
#define EIR_r8               ((unsigned short int)1<<8)
#define EIR_r7                (1<<7)
#define EIR_PKTIF             (1<<6)
#define EIR_DMAIF             (1<<5)
#define EIR_r4                (1<<4)
#define EIR_TXIF              (1<<3)
#define EIR_TXABTIF           (1<<2)
#define EIR_RXABTIF           (1<<1)
#define EIR_PCFULIF           (1)

// ECON1 bits ----------
#define ECON1_MODEXST       ((unsigned short int)1<<15)
#define ECON1_HASHEN        ((unsigned short int)1<<14)
#define ECON1_HASHOP        ((unsigned short int)1<<13)
#define ECON1_HASHLST       ((unsigned short int)1<<12)
#define ECON1_AESST         ((unsigned short int)1<<11)
#define ECON1_AESOP1        ((unsigned short int)1<<10)
#define ECON1_AESOP0        ((unsigned short int)1<<9)
#define ECON1_PKTDEC        ((unsigned short int)1<<8)
#define ECON1_FCOP1          (1<<7)
#define ECON1_FCOP0          (1<<6)
#define ECON1_DMAST          (1<<5)
#define ECON1_DMACPY         (1<<4)
#define ECON1_DMACSSD        (1<<3)
#define ECON1_DMANOCS        (1<<2)
#define ECON1_TXRTS          (1<<1)
#define ECON1_RXEN           (1)

// ETXSTAT bits --------
#define ETXSTAT_r12         ((unsigned short int)1<<12)
#define ETXSTAT_r11         ((unsigned short int)1<<11)
#define ETXSTAT_LATECOL     ((unsigned short int)1<<10)
#define ETXSTAT_MAXCOL      ((unsigned short int)1<<9)
#define ETXSTAT_EXDEFER     ((unsigned short int)1<<8)
#define ETXSTAT_DEFER        (1<<7)
#define ETXSTAT_r6           (1<<6)
#define ETXSTAT_r5           (1<<5)
#define ETXSTAT_CRCBAD       (1<<4)
#define ETXSTAT_COLCNT3      (1<<3)
#define ETXSTAT_COLCNT2      (1<<2)
#define ETXSTAT_COLCNT1      (1<<1)
#define ETXSTAT_COLCNT0      (1)

// ERXFCON bits --------
#define ERXFCON_HTEN        ((unsigned short int)1<<15)
#define ERXFCON_MPEN        ((unsigned short int)1<<14)
#define ERXFCON_NOTPM       ((unsigned short int)1<<12)
#define ERXFCON_PMEN3       ((unsigned short int)1<<11)
#define ERXFCON_PMEN2       ((unsigned short int)1<<10)
#define ERXFCON_PMEN1       ((unsigned short int)1<<9)
#define ERXFCON_PMEN0       ((unsigned short int)1<<8)
#define ERXFCON_CRCEEN       (1<<7)
#define ERXFCON_CRCEN        (1<<6)
#define ERXFCON_RUNTEEN      (1<<5)
#define ERXFCON_RUNTEN       (1<<4)
#define ERXFCON_UCEN         (1<<3)
#define ERXFCON_NOTMEEN      (1<<2)
#define ERXFCON_MCEN         (1<<1)
#define ERXFCON_BCEN         (1)

// MACON1 bits ---------
#define MACON1_r15          ((unsigned short int)1<<15)
#define MACON1_r14          ((unsigned short int)1<<14)
#define MACON1_r11          ((unsigned short int)1<<11)
#define MACON1_r10          ((unsigned short int)1<<10)
#define MACON1_r9           ((unsigned short int)1<<9)
#define MACON1_r8           ((unsigned short int)1<<8)
#define MACON1_LOOPBK        (1<<4)
#define MACON1_r3            (1<<3)
#define MACON1_RXPAUS        (1<<2)
#define MACON1_PASSALL       (1<<1)
#define MACON1_r0            (1)

// MACON2 bits ---------
#define MACON2_DEFER        ((unsigned short int)1<<14)
#define MACON2_BPEN         ((unsigned short int)1<<13)
#define MACON2_NOBKOFF      ((unsigned short int)1<<12)
#define MACON2_r9           ((unsigned short int)1<<9)
#define MACON2_r8           ((unsigned short int)1<<8)
#define MACON2_PADCFG2       (1<<7)
#define MACON2_PADCFG1       (1<<6)
#define MACON2_PADCFG0       (1<<5)
#define MACON2_TXCRCEN       (1<<4)
#define MACON2_PHDREN        (1<<3)
#define MACON2_HFRMEN        (1<<2)
#define MACON2_r1            (1<<1)
#define MACON2_FULDPX        (1)

// MABBIPG bits --------
#define MABBIPG_BBIPG6       (1<<6)
#define MABBIPG_BBIPG5       (1<<5)
#define MABBIPG_BBIPG4       (1<<4)
#define MABBIPG_BBIPG3       (1<<3)
#define MABBIPG_BBIPG2       (1<<2)
#define MABBIPG_BBIPG1       (1<<1)
#define MABBIPG_BBIPG0       (1)

// MAIPG bits ----------
#define MAIPG_r14            ((unsigned short int)1<<14)
#define MAIPG_r13            ((unsigned short int)1<<13)
#define MAIPG_r12            ((unsigned short int)1<<12)
#define MAIPG_r11            ((unsigned short int)1<<11)
#define MAIPG_r10            ((unsigned short int)1<<10)
#define MAIPG_r9             ((unsigned short int)1<<9)
#define MAIPG_r8             ((unsigned short int)1<<8)
#define MAIPG_IPG6           (1<<6)
#define MAIPG_IPG5           (1<<5)
#define MAIPG_IPG4           (1<<4)
#define MAIPG_IPG3           (1<<3)
#define MAIPG_IPG2           (1<<2)
#define MAIPG_IPG1           (1<<1)
#define MAIPG_IPG0           (1)

// MACLCON bits --------
#define MACLCON_r13          ((unsigned short int)1<<13)
#define MACLCON_r12          ((unsigned  short int)1<<12)
#define MACLCON_r11          ((unsigned short int)1<<11)
#define MACLCON_r10          ((unsigned short int)1<<10)
#define MACLCON_r9           ((unsigned short int)1<<9)
#define MACLCON_r8           ((unsigned short int)1<<8)
#define MACLCON_MAXRET3      (1<<3)
#define MACLCON_MAXRET2      (1<<2)
#define MACLCON_MAXRET1      (1<<1)
#define MACLCON_MAXRET0      (1)

// MICMD bits ----------
#define MICMD_MIISCAN        (1<<1)
#define MICMD_MIIRD          (1)

// MIREGADR bits -------
#define MIREGADR_r12        ((unsigned short int)1<<12)
#define MIREGADR_r11        ((unsigned short int)1<<11)
#define MIREGADR_r10        ((unsigned short int)1<<10)
#define MIREGADR_r9                ((unsigned short int)1<<9)
#define MIREGADR_r8                ((unsigned short int)1<<8)
#define MIREGADR_PHREG4        (1<<4)
#define MIREGADR_PHREG3        (1<<3)
#define MIREGADR_PHREG2        (1<<2)
#define MIREGADR_PHREG1        (1<<1)
#define MIREGADR_PHREG0        (1)

// MISTAT bits ---------
#define MISTAT_r3                (1<<3)
#define        MISTAT_NVALID        (1<<2)
#define        MISTAT_SCAN                (1<<1)
#define        MISTAT_BUSY                (1)

// ECON2 bits ----------
#define ECON2_ETHEN                ((unsigned short int)1<<15)
#define ECON2_STRCH                ((unsigned short int)1<<14)
#define ECON2_TXMAC                ((unsigned short int)1<<13)
#define ECON2_SHA1MD5        ((unsigned short int)1<<12)
#define ECON2_COCON3        ((unsigned short int)1<<11)
#define ECON2_COCON2        ((unsigned short int)1<<10)
#define ECON2_COCON1        ((unsigned short int)1<<9)
#define ECON2_COCON0        ((unsigned short int)1<<8)
#define ECON2_AUTOFC        (1<<7)
#define ECON2_TXRST                (1<<6)
#define ECON2_RXRST                (1<<5)
#define ECON2_ETHRST        (1<<4)
#define ECON2_MODLEN1        (1<<3)
#define ECON2_MODLEN0        (1<<2)
#define ECON2_AESLEN1        (1<<1)
#define ECON2_AESLEN0        (1)

// ERXWM bits ----------
#define ERXWM_RXFWM7        ((unsigned short int)1<<15)
#define ERXWM_RXFWM6        ((unsigned short int)1<<14)
#define ERXWM_RXFWM5        ((unsigned short int)1<<13)
#define ERXWM_RXFWM4        ((unsigned short int)1<<12)
#define ERXWM_RXFWM3        ((unsigned short int)1<<11)
#define ERXWM_RXFWM2        ((unsigned short int)1<<10)
#define ERXWM_RXFWM1        ((unsigned short int)1<<9)
#define ERXWM_RXFWM0        ((unsigned short int)1<<8)
#define ERXWM_RXEWM7        (1<<7)
#define ERXWM_RXEWM6        (1<<6)
#define ERXWM_RXEWM5        (1<<5)
#define ERXWM_RXEWM4        (1<<4)
#define ERXWM_RXEWM3        (1<<3)
#define ERXWM_RXEWM2        (1<<2)
#define ERXWM_RXEWM1        (1<<1)
#define ERXWM_RXEWM0        (1)

// EIE bits ------------
#define EIE_INTIE                ((unsigned short int)1<<15)
#define EIE_MODEXIE                ((unsigned short int)1<<14)
#define EIE_HASHIE                ((unsigned short int)1<<13)
#define EIE_AESIE                ((unsigned short int)1<<12)
#define EIE_LINKIE                ((unsigned short int)1<<11)
#define EIE_PRDYIE                ((unsigned short int)1<<10)
#define EIE_r9                        ((unsigned short int)1<<9)
#define EIE_r8                        ((unsigned short int)1<<8)
#define EIE_r7                        (1<<7)
#define EIE_PKTIE                (1<<6)
#define EIE_DMAIE                (1<<5)
#define EIE_r4                        (1<<4)
#define EIE_TXIE                (1<<3)
#define EIE_TXABTIE                (1<<2)
#define EIE_RXABTIE                (1<<1)
#define EIE_PCFULIE                (1)

// EIDLED bits ---------
#define EIDLED_LACFG3        ((unsigned short int)1<<15)
#define EIDLED_LACFG2        ((unsigned short int)1<<14)
#define EIDLED_LACFG1        ((unsigned short int)1<<13)
#define EIDLED_LACFG0        ((unsigned short int)1<<12)
#define EIDLED_LBCFG3        ((unsigned short int)1<<11)
#define EIDLED_LBCFG2        ((unsigned short int)1<<10)
#define EIDLED_LBCFG1        ((unsigned short int)1<<9)
#define EIDLED_LBCFG0        ((unsigned short int)1<<8)
#define EIDLED_DEVID2        (1<<7)
#define EIDLED_DEVID1        (1<<6)
#define EIDLED_DEVID0        (1<<5)
#define EIDLED_REVID4        (1<<4)
#define EIDLED_REVID3        (1<<3)
#define EIDLED_REVID2        (1<<2)
#define EIDLED_REVID1        (1<<1)
#define EIDLED_REVID0        (1)

// PHCON1 bits ---------
#define PHCON1_PRST          ((unsigned short int)1<<15)
#define PHCON1_PLOOPBK       ((unsigned short int)1<<14)
#define PHCON1_SPD100        ((unsigned short int)1<<13)
#define PHCON1_ANEN          ((unsigned short int)1<<12)
#define PHCON1_PSLEEP        ((unsigned short int)1<<11)
#define PHCON1_r10           ((unsigned short int)1<<10)
#define PHCON1_RENEG         ((unsigned short int)1<<9)
#define PHCON1_PFULDPX       ((unsigned short int)1<<8)
#define PHCON1_r7            (1<<7)
#define PHCON1_r6            (1<<6)
#define PHCON1_r5            (1<<5)
#define PHCON1_r4            (1<<4)
#define PHCON1_r3            (1<<3)
#define PHCON1_r2            (1<<2)
#define PHCON1_r1            (1<<1)
#define PHCON1_r0            (1)

// PHSTAT1 bits --------
#define PHSTAT1_r15          ((unsigned short int)1<<15)
#define PHSTAT1_FULL100      ((unsigned short int)1<<14)
#define PHSTAT1_HALF100      ((unsigned short int)1<<13)
#define PHSTAT1_FULL10       ((unsigned short int)1<<12)
#define PHSTAT1_HALF10       ((unsigned short int)1<<11)
#define PHSTAT1_r10          ((unsigned short int)1<<10)
#define PHSTAT1_r9           ((unsigned short int)1<<9)
#define PHSTAT1_r8           ((unsigned short int)1<<8)
#define PHSTAT1_r7           (1<<7)
#define PHSTAT1_r6           (1<<6)
#define PHSTAT1_ANDONE       (1<<5)
#define PHSTAT1_LRFAULT      (1<<4)
#define PHSTAT1_ANABLE       (1<<3)
#define PHSTAT1_LLSTAT       (1<<2)
#define PHSTAT1_r1           (1<<1)
#define PHSTAT1_EXTREGS      (1)

// PHANA bits ----------
#define PHANA_ADNP           ((unsigned short int)1<<15)
#define PHANA_r14            ((unsigned short int)1<<14)
#define PHANA_ADFAULT        ((unsigned short int)1<<13)
#define PHANA_r12            ((unsigned short int)1<<12)
#define PHANA_ADPAUS1        ((unsigned short int)1<<11)
#define PHANA_ADPAUS0        ((unsigned short int)1<<10)
#define PHANA_r9             ((unsigned short int)1<<9)
#define PHANA_AD100FD        ((unsigned short int)1<<8)
#define PHANA_AD100          (1<<7)
#define PHANA_AD10FD         (1<<6)
#define PHANA_AD10           (1<<5)
#define PHANA_ADIEEE4        (1<<4)
#define PHANA_ADIEEE3        (1<<3)
#define PHANA_ADIEEE2        (1<<2)
#define PHANA_ADIEEE1        (1<<1)
#define PHANA_ADIEEE0        (1)

// PHANLPA bits --------
#define PHANLPA_LPNP         ((unsigned short int)1<<15)
#define PHANLPA_LPACK        ((unsigned short int)1<<14)
#define PHANLPA_LPFAULT      ((unsigned short int)1<<13)
#define PHANLPA_r12          ((unsigned short int)1<<12)
#define PHANLPA_LPPAUS1      ((unsigned short int)1<<11)
#define PHANLPA_LPPAUS0      ((unsigned short int)1<<10)
#define PHANLPA_LP100T4      ((unsigned short int)1<<9)
#define PHANLPA_LP100FD      ((unsigned short int)1<<8)
#define PHANLPA_LP100        (1<<7)
#define PHANLPA_LP10FD       (1<<6)
#define PHANLPA_LP10         (1<<5)
#define PHANLPA_LPIEEE4      (1<<4)
#define PHANLPA_LPIEEE3      (1<<3)
#define PHANLPA_LPIEEE2      (1<<2)
#define PHANLPA_LPIEEE1      (1<<1)
#define PHANLPA_LPIEEE0      (1)

// PHANE bits ----------
#define PHANE_r15            ((unsigned short int)1<<15)
#define PHANE_r14            ((unsigned short int)1<<14)
#define PHANE_r13            ((unsigned short int)1<<13)
#define PHANE_r12            ((unsigned short int)1<<12)
#define PHANE_r11            ((unsigned short int)1<<11)
#define PHANE_r10            ((unsigned short int)1<<10)
#define PHANE_r9             ((unsigned short int)1<<9)
#define PHANE_r8             ((unsigned short int)1<<8)
#define PHANE_r7             (1<<7)
#define PHANE_r6             (1<<6)
#define PHANE_r5             (1<<5)
#define PHANE_PDFLT          (1<<4)
#define PHANE_r3             (1<<3)
#define PHANE_r2             (1<<2)
#define PHANE_LPARCD         (1<<1)
#define PHANA_LPANABL        (1)

// PHCON2 bits ---------
#define PHCON2_r15           ((unsigned short int)1<<15)
#define PHCON2_r14           ((unsigned short int)1<<14)
#define PHCON2_EDPWRDN       ((unsigned short int)1<<13)
#define PHCON2_r12           ((unsigned short int)1<<12)
#define PHCON2_EDTHRES       ((unsigned short int)1<<11)
#define PHCON2_r10           ((unsigned short int)1<<10)
#define PHCON2_r9            ((unsigned short int)1<<9)
#define PHCON2_r8            ((unsigned short int)1<<8)
#define PHCON2_r7            (1<<7)
#define PHCON2_r6            (1<<6)
#define PHCON2_r5            (1<<5)
#define PHCON2_r4            (1<<4)
#define PHCON2_r3            (1<<3)
#define PHCON2_FRCLNK        (1<<2)
#define PHCON2_EDSTAT        (1<<1)
#define PHCON2_r0            (1)

// PHSTAT2 bits ---------
#define PHSTAT2_r15          ((unsigned short int)1<<15)
#define PHSTAT2_r14          ((unsigned short int)1<<14)
#define PHSTAT2_r13          ((unsigned short int)1<<13)
#define PHSTAT2_r12          ((unsigned short int)1<<12)
#define PHSTAT2_r11          ((unsigned short int)1<<11)
#define PHSTAT2_r10          ((unsigned short int)1<<10)
#define PHSTAT2_r9           ((unsigned short int)1<<9)
#define PHSTAT2_r8           ((unsigned short int)1<<8)
#define PHSTAT2_r7           (1<<7)
#define PHSTAT2_r6           (1<<6)
#define PHSTAT2_r5           (1<<5)
#define PHSTAT2_PLRITY       (1<<4)
#define PHSTAT2_r3           (1<<3)
#define PHSTAT2_r2           (1<<2)
#define PHSTAT2_r1           (1<<1)
#define PHSTAT2_r0           (1)

// PHSTAT3 bits --------
#define PHSTAT3_r15          ((unsigned short int)1<<15)
#define PHSTAT3_r14          ((unsigned short int)1<<14)
#define PHSTAT3_r13          ((unsigned short int)1<<13)
#define PHSTAT3_r12          ((unsigned short int)1<<12)
#define PHSTAT3_r11          ((unsigned short int)1<<11)
#define PHSTAT3_r10          ((unsigned short int)1<<10)
#define PHSTAT3_r9           ((unsigned short int)1<<9)
#define PHSTAT3_r8           ((unsigned short int)1<<8)
#define PHSTAT3_r7           (1<<7)
#define PHSTAT3_r6           (1<<6)
#define PHSTAT3_r5           (1<<5)
#define PHSTAT3_SPDDPX2      (1<<4)
#define PHSTAT3_SPDDPX1      (1<<3)
#define PHSTAT3_SPDDPX0      (1<<2)
#define PHSTAT3_r1           (1<<1)
#define PHSTAT3_r0           (1)


#endif