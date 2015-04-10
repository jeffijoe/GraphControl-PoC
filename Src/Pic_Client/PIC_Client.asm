
_main:

;PIC_Client.c,12 :: 		void main() {
;PIC_Client.c,17 :: 		int lessThan = 0;
	CLRF        main_lessThan_L0+0 
	CLRF        main_lessThan_L0+1 
	CLRF        main_moreThan_L0+0 
	CLRF        main_moreThan_L0+1 
;PIC_Client.c,20 :: 		ANSELA = 0x02;             // Configure RA1 pin as analog
	MOVLW       2
	MOVWF       ANSELA+0 
;PIC_Client.c,21 :: 		ANSELC = 0;
	CLRF        ANSELC+0 
;PIC_Client.c,22 :: 		ANSELD = 0;
	CLRF        ANSELD+0 
;PIC_Client.c,23 :: 		TRISD = 0;
	CLRF        TRISD+0 
;PIC_Client.c,24 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	MOVLW       3
	MOVWF       SPBRGH+0 
	MOVLW       64
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;PIC_Client.c,25 :: 		Delay_ms(100);
	MOVLW       5
	MOVWF       R11, 0
	MOVLW       15
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 1
	BRA         L_main0
	DECFSZ      R12, 1, 1
	BRA         L_main0
	DECFSZ      R11, 1, 1
	BRA         L_main0
;PIC_Client.c,26 :: 		UART1_Write_Text("\n\rStart \n\r");
	MOVLW       ?lstr1_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,27 :: 		MACInit(void);
	CALL        _MACInit+0, 0
;PIC_Client.c,28 :: 		Delay_ms(100);
	MOVLW       5
	MOVWF       R11, 0
	MOVLW       15
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main1:
	DECFSZ      R13, 1, 1
	BRA         L_main1
	DECFSZ      R12, 1, 1
	BRA         L_main1
	DECFSZ      R11, 1, 1
	BRA         L_main1
;PIC_Client.c,29 :: 		ChkLink();
	CALL        _ChkLink+0, 0
;PIC_Client.c,31 :: 		do {
L_main2:
;PIC_Client.c,32 :: 		adc_rd = ADC_Read(1);    // get ADC value from 1st channel
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _adc_rd+0 
	MOVF        R1, 0 
	MOVWF       _adc_rd+1 
;PIC_Client.c,34 :: 		lessThan = oldadc_rd - FluxLimit;
	MOVLW       5
	SUBWF       _oldadc_rd+0, 0 
	MOVWF       main_lessThan_L0+0 
	MOVLW       0
	SUBWFB      _oldadc_rd+1, 0 
	MOVWF       main_lessThan_L0+1 
;PIC_Client.c,35 :: 		moreThan = oldadc_rd + FluxLimit;
	MOVLW       5
	ADDWF       _oldadc_rd+0, 0 
	MOVWF       main_moreThan_L0+0 
	MOVLW       0
	ADDWFC      _oldadc_rd+1, 0 
	MOVWF       main_moreThan_L0+1 
;PIC_Client.c,37 :: 		if (ChkPck()) {
	CALL        _ChkPck+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main5
;PIC_Client.c,39 :: 		arpData = (PArpStruct) Packet;
	MOVLW       _Packet+0
	MOVWF       main_arpData_L0+0 
	MOVLW       hi_addr(_Packet+0)
	MOVWF       main_arpData_L0+1 
;PIC_Client.c,40 :: 		if (arpData->eth.Type == 0x0608) // Arp Request = 0x0806
	MOVLW       12
	ADDWF       main_arpData_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      main_arpData_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	XORLW       6
	BTFSS       STATUS+0, 2 
	GOTO        L__main285
	MOVLW       8
	XORWF       R1, 0 
L__main285:
	BTFSS       STATUS+0, 2 
	GOTO        L_main6
;PIC_Client.c,42 :: 		if (!HandleArpPackage(arpData))
	MOVF        main_arpData_L0+0, 0 
	MOVWF       FARG_HandleArpPackage_arpData+0 
	MOVF        main_arpData_L0+1, 0 
	MOVWF       FARG_HandleArpPackage_arpData+1 
	CALL        _HandleArpPackage+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main7
;PIC_Client.c,44 :: 		UART1_Write_Text("Ukendt device");
	MOVLW       ?lstr2_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,45 :: 		}
L_main7:
;PIC_Client.c,46 :: 		}
	GOTO        L_main8
L_main6:
;PIC_Client.c,48 :: 		else if (arpData->eth.Type == 0x0008) // IP = 0x0800
	MOVLW       12
	ADDWF       main_arpData_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      main_arpData_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main286
	MOVLW       8
	XORWF       R1, 0 
L__main286:
	BTFSS       STATUS+0, 2 
	GOTO        L_main9
;PIC_Client.c,50 :: 		ipData = (PIpStruct) Packet;
	MOVLW       _Packet+0
	MOVWF       main_ipData_L0+0 
	MOVLW       hi_addr(_Packet+0)
	MOVWF       main_ipData_L0+1 
;PIC_Client.c,51 :: 		if (IsThisDevice(ipData->Ip.DestAddr)) {
	MOVLW       14
	ADDWF       main_ipData_L0+0, 0 
	MOVWF       FARG_IsThisDevice_ipAddr+0 
	MOVLW       0
	ADDWFC      main_ipData_L0+1, 0 
	MOVWF       FARG_IsThisDevice_ipAddr+1 
	MOVLW       16
	ADDWF       FARG_IsThisDevice_ipAddr+0, 1 
	MOVLW       0
	ADDWFC      FARG_IsThisDevice_ipAddr+1, 1 
	CALL        _IsThisDevice+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
;PIC_Client.c,52 :: 		switch (ipData->Ip.Proto)
	MOVLW       14
	ADDWF       main_ipData_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      main_ipData_L0+1, 0 
	MOVWF       R1 
	MOVLW       9
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	GOTO        L_main11
;PIC_Client.c,54 :: 		case PROTO_ICMP:
L_main13:
;PIC_Client.c,55 :: 		Icmp((PIcmpStruct) Packet, PckLen);
	MOVLW       _Packet+0
	MOVWF       FARG_Icmp_PIcmpData+0 
	MOVLW       hi_addr(_Packet+0)
	MOVWF       FARG_Icmp_PIcmpData+1 
	MOVF        _PckLen+0, 0 
	MOVWF       FARG_Icmp_PckLen+0 
	CALL        _Icmp+0, 0
;PIC_Client.c,56 :: 		break;
	GOTO        L_main12
;PIC_Client.c,57 :: 		case PROTO_UDP:
L_main14:
;PIC_Client.c,58 :: 		HandleUdpPackage((PUdpStruct) Packet);
	MOVLW       _Packet+0
	MOVWF       FARG_HandleUdpPackage_udpData+0 
	MOVLW       hi_addr(_Packet+0)
	MOVWF       FARG_HandleUdpPackage_udpData+1 
	CALL        _HandleUdpPackage+0, 0
;PIC_Client.c,59 :: 		break;
	GOTO        L_main12
;PIC_Client.c,60 :: 		case PROTO_TCP:
L_main15:
;PIC_Client.c,61 :: 		HandleTcpPackage((PTcpStruct) Packet);
	MOVLW       _Packet+0
	MOVWF       FARG_HandleTcpPackage_tcpData+0 
	MOVLW       hi_addr(_Packet+0)
	MOVWF       FARG_HandleTcpPackage_tcpData+1 
	CALL        _HandleTcpPackage+0, 0
;PIC_Client.c,62 :: 		break;
	GOTO        L_main12
;PIC_Client.c,63 :: 		}
L_main11:
	MOVFF       FLOC__main+0, FSR0
	MOVFF       FLOC__main+1, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_main13
	MOVFF       FLOC__main+0, FSR0
	MOVFF       FLOC__main+1, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       17
	BTFSC       STATUS+0, 2 
	GOTO        L_main14
	MOVFF       FLOC__main+0, FSR0
	MOVFF       FLOC__main+1, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       6
	BTFSC       STATUS+0, 2 
	GOTO        L_main15
L_main12:
;PIC_Client.c,64 :: 		}
L_main10:
;PIC_Client.c,65 :: 		}
L_main9:
L_main8:
;PIC_Client.c,66 :: 		}
	GOTO        L_main16
L_main5:
;PIC_Client.c,67 :: 		else if (destinationPort != 0 && (lessThan > adc_rd || moreThan < adc_rd))
	MOVLW       0
	XORWF       _destinationPort+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main287
	MOVLW       0
	XORWF       _destinationPort+0, 0 
L__main287:
	BTFSC       STATUS+0, 2 
	GOTO        L_main21
	MOVF        main_lessThan_L0+1, 0 
	SUBWF       _adc_rd+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main288
	MOVF        main_lessThan_L0+0, 0 
	SUBWF       _adc_rd+0, 0 
L__main288:
	BTFSS       STATUS+0, 0 
	GOTO        L__main279
	MOVF        _adc_rd+1, 0 
	SUBWF       main_moreThan_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main289
	MOVF        _adc_rd+0, 0 
	SUBWF       main_moreThan_L0+0, 0 
L__main289:
	BTFSS       STATUS+0, 0 
	GOTO        L__main279
	GOTO        L_main21
L__main279:
L__main278:
;PIC_Client.c,69 :: 		oldadc_rd = adc_rd;
	MOVF        _adc_rd+0, 0 
	MOVWF       _oldadc_rd+0 
	MOVF        _adc_rd+1, 0 
	MOVWF       _oldadc_rd+1 
;PIC_Client.c,70 :: 		SendMessage();
	CALL        _SendMessage+0, 0
;PIC_Client.c,71 :: 		}
L_main21:
L_main16:
;PIC_Client.c,72 :: 		} while (true);
	GOTO        L_main2
;PIC_Client.c,73 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_SendMessage:

;PIC_Client.c,75 :: 		void SendMessage(void) {
;PIC_Client.c,80 :: 		intToShort.IntVal = adc_rd;
	MOVF        _adc_rd+0, 0 
	MOVWF       _IntToShort+0 
	MOVF        _adc_rd+1, 0 
	MOVWF       _IntToShort+1 
;PIC_Client.c,82 :: 		tcpPacket->tcp.SourcePort = 0x8D13; //5005
	MOVLW       34
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       FSR1H 
	MOVLW       19
	MOVWF       POSTINC1+0 
	MOVLW       141
	MOVWF       POSTINC1+0 
;PIC_Client.c,83 :: 		tcpPacket->tcp.DestPort = destinationPort;
	MOVLW       34
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _destinationPort+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        _destinationPort+1, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,84 :: 		tcpPacket->uddata[0] = IntToShort.ShortVal[0];
	MOVLW       54
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       FSR1H 
	MOVF        _IntToShort+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,85 :: 		tcpPacket->uddata[1] = IntToShort.ShortVal[1];
	MOVLW       54
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _IntToShort+1, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,86 :: 		tcpPacket->tcp.DataOffset.Reserved3 = 0x00;
	MOVLW       34
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       R3 
	MOVFF       R2, FSR0
	MOVFF       R3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       240
	ANDWF       R0, 1 
	MOVFF       R2, FSR1
	MOVFF       R3, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,87 :: 		tcpPacket->tcp.DataOffset.Val = 0x05;
	MOVLW       34
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       R3 
	MOVFF       R2, FSR0
	MOVFF       R3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       80
	XORWF       R1, 0 
	MOVWF       R0 
	MOVLW       240
	ANDWF       R0, 1 
	MOVF        R1, 0 
	XORWF       R0, 1 
	MOVFF       R2, FSR1
	MOVFF       R3, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,88 :: 		tcpPacket->tcp.UrgentPointer = 0x00;
	MOVLW       34
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       18
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;PIC_Client.c,90 :: 		TCPDataLen = dataLen - (tcpPacket->tcp.DataOffset.Val * 4);
	MOVLW       34
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R5 
	MOVLW       12
	ADDWF       R4, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R5, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       240
	ANDWF       R0, 0 
	MOVWF       R3 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	RLCF        R1, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	RLCF        R1, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	SUBWF       SendMessage_dataLen_L0+0, 0 
	MOVWF       R0 
	MOVF        R1, 0 
	SUBWFB      SendMessage_dataLen_L0+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _TCPDataLen+0 
	MOVF        R1, 0 
	MOVWF       _TCPDataLen+1 
;PIC_Client.c,91 :: 		sequenceNumber += TCPDataLen;
	MOVLW       0
	MOVWF       R2 
	MOVWF       R3 
	MOVF        _sequenceNumber+0, 0 
	ADDWF       R0, 1 
	MOVF        _sequenceNumber+1, 0 
	ADDWFC      R1, 1 
	MOVF        _sequenceNumber+2, 0 
	ADDWFC      R2, 1 
	MOVF        _sequenceNumber+3, 0 
	ADDWFC      R3, 1 
	MOVF        R0, 0 
	MOVWF       _sequenceNumber+0 
	MOVF        R1, 0 
	MOVWF       _sequenceNumber+1 
	MOVF        R2, 0 
	MOVWF       _sequenceNumber+2 
	MOVF        R3, 0 
	MOVWF       _sequenceNumber+3 
;PIC_Client.c,93 :: 		tcpPacket->tcp.SeqNumber = SwapByteOrder(sequenceNumber);
	MOVLW       4
	ADDWF       R4, 0 
	MOVWF       FLOC__SendMessage+0 
	MOVLW       0
	ADDWFC      R5, 0 
	MOVWF       FLOC__SendMessage+1 
	MOVF        R0, 0 
	MOVWF       FARG_swapByteOrder_ui+0 
	MOVF        R1, 0 
	MOVWF       FARG_swapByteOrder_ui+1 
	MOVF        R2, 0 
	MOVWF       FARG_swapByteOrder_ui+2 
	MOVF        R3, 0 
	MOVWF       FARG_swapByteOrder_ui+3 
	CALL        _swapByteOrder+0, 0
	MOVFF       FLOC__SendMessage+0, FSR1
	MOVFF       FLOC__SendMessage+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,94 :: 		tcpPacket->tcp.AckNumber = 0x00000000;
	MOVLW       34
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       8
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;PIC_Client.c,95 :: 		tcpPacket->tcp.Flags.byte = 0; //dis is gud coed
	MOVLW       34
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       13
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,99 :: 		tcpPacket->tcp.Flags.bits.flagACK = 1;
	MOVLW       34
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       13
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 4 
;PIC_Client.c,101 :: 		tcpPacket->tcp.Flags.bits.flagPSH = 1;
	MOVLW       34
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       13
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 3 
;PIC_Client.c,103 :: 		dataLen = sizeof(IpStruct) + 2;
	MOVLW       36
	MOVWF       SendMessage_dataLen_L0+0 
	MOVLW       0
	MOVWF       SendMessage_dataLen_L0+1 
;PIC_Client.c,106 :: 		memcpy(tcpPacket->ip.ScrAddr, destinationIp, 4);
	MOVLW       14
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       FARG_memcpy_d1+0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       FARG_memcpy_d1+1 
	MOVLW       12
	ADDWF       FARG_memcpy_d1+0, 1 
	MOVLW       0
	ADDWFC      FARG_memcpy_d1+1, 1 
	MOVLW       _destinationIp+0
	MOVWF       FARG_memcpy_s1+0 
	MOVLW       hi_addr(_destinationIp+0)
	MOVWF       FARG_memcpy_s1+1 
	MOVLW       4
	MOVWF       FARG_memcpy_n+0 
	MOVLW       0
	MOVWF       FARG_memcpy_n+1 
	CALL        _memcpy+0, 0
;PIC_Client.c,107 :: 		memcpy(tcpPacket->ip.DestAddr, MyIpAddr, 4);
	MOVLW       14
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       FARG_memcpy_d1+0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       FARG_memcpy_d1+1 
	MOVLW       16
	ADDWF       FARG_memcpy_d1+0, 1 
	MOVLW       0
	ADDWFC      FARG_memcpy_d1+1, 1 
	MOVLW       _myIpAddr+0
	MOVWF       FARG_memcpy_s1+0 
	MOVLW       hi_addr(_myIpAddr+0)
	MOVWF       FARG_memcpy_s1+1 
	MOVLW       4
	MOVWF       FARG_memcpy_n+0 
	MOVLW       0
	MOVWF       FARG_memcpy_n+1 
	CALL        _memcpy+0, 0
;PIC_Client.c,109 :: 		TCPLen = sizeof(TcpHdr) + 2; // 2 for 2 bytes of data.
	MOVLW       22
	MOVWF       _TCPLen+0 
	MOVLW       0
	MOVWF       _TCPLen+1 
;PIC_Client.c,111 :: 		tcpPacket->ip.Proto = PROTO_TCP;
	MOVLW       14
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       9
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       6
	MOVWF       POSTINC1+0 
;PIC_Client.c,112 :: 		tcpPacket->ip.Ver_Len = 0x45;
	MOVLW       14
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       FSR1H 
	MOVLW       69
	MOVWF       POSTINC1+0 
;PIC_Client.c,113 :: 		tcpPacket->ip.Tos = 0x00;
	MOVLW       14
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,114 :: 		tcpPacket->ip.PktLen = _SWAP(sizeof(IpHdr) + TCPLen);   //sizeof(TcpHdr) + 2)
	MOVLW       14
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       20
	ADDWF       _TCPLen+0, 0 
	MOVWF       R5 
	MOVLW       0
	ADDWFC      _TCPLen+1, 0 
	MOVWF       R6 
	MOVF        R6, 0 
	MOVWF       R3 
	CLRF        R4 
	MOVF        R5, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R3, 0 
	IORWF       R0, 1 
	MOVF        R4, 0 
	IORWF       R1, 1 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,115 :: 		tcpPacket->ip.Id = 0x287;
	MOVLW       14
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       135
	MOVWF       POSTINC1+0 
	MOVLW       2
	MOVWF       POSTINC1+0 
;PIC_Client.c,116 :: 		tcpPacket->ip.Offset = 0x0000;
	MOVLW       14
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       6
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;PIC_Client.c,117 :: 		tcpPacket->ip.Ttl = 128;
	MOVLW       14
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       8
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       128
	MOVWF       POSTINC1+0 
;PIC_Client.c,118 :: 		tcpPacket->ip.PktLen = _SWAP(dataLen);
	MOVLW       14
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        SendMessage_dataLen_L0+1, 0 
	MOVWF       R3 
	MOVLW       0
	BTFSC       SendMessage_dataLen_L0+1, 7 
	MOVLW       255
	MOVWF       R4 
	MOVF        SendMessage_dataLen_L0+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R3, 0 
	IORWF       R0, 1 
	MOVF        R4, 0 
	IORWF       R1, 1 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,120 :: 		memcpy(tcpPacket->eth.ScrMac, destinationMac, 6);
	MOVLW       6
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       FARG_memcpy_d1+0 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       FARG_memcpy_d1+1 
	MOVLW       _destinationMac+0
	MOVWF       FARG_memcpy_s1+0 
	MOVLW       hi_addr(_destinationMac+0)
	MOVWF       FARG_memcpy_s1+1 
	MOVLW       6
	MOVWF       FARG_memcpy_n+0 
	MOVLW       0
	MOVWF       FARG_memcpy_n+1 
	CALL        _memcpy+0, 0
;PIC_Client.c,121 :: 		memcpy(tcpPacket->eth.DestMac, myMacAddr, 6);
	MOVF        SendMessage_tcpPacket_L0+0, 0 
	MOVWF       FARG_memcpy_d1+0 
	MOVF        SendMessage_tcpPacket_L0+1, 0 
	MOVWF       FARG_memcpy_d1+1 
	MOVLW       _myMacAddr+0
	MOVWF       FARG_memcpy_s1+0 
	MOVLW       hi_addr(_myMacAddr+0)
	MOVWF       FARG_memcpy_s1+1 
	MOVLW       6
	MOVWF       FARG_memcpy_n+0 
	MOVLW       0
	MOVWF       FARG_memcpy_n+1 
	CALL        _memcpy+0, 0
;PIC_Client.c,123 :: 		tcpPacket->eth.Type = 0x0008;
	MOVLW       12
	ADDWF       SendMessage_tcpPacket_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      SendMessage_tcpPacket_L0+1, 0 
	MOVWF       FSR1H 
	MOVLW       8
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
;PIC_Client.c,125 :: 		pseudoData = (PPseudoStruct) PseudoPacket;
	MOVLW       _PseudoPacket+0
	MOVWF       SendMessage_pseudoData_L0+0 
	MOVLW       hi_addr(_PseudoPacket+0)
	MOVWF       SendMessage_pseudoData_L0+1 
;PIC_Client.c,126 :: 		Tcp_CheckSum((PPseudoStruct) pseudoData, (PTcpStruct) tcpPacket);
	MOVF        SendMessage_pseudoData_L0+0, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpPseudoData+0 
	MOVF        SendMessage_pseudoData_L0+1, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpPseudoData+1 
	MOVF        SendMessage_tcpPacket_L0+0, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpData+0 
	MOVF        SendMessage_tcpPacket_L0+1, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpData+1 
	CALL        _Tcp_CheckSum+0, 0
;PIC_Client.c,128 :: 		UART1_Write_Text("Writing packet!");
	MOVLW       ?lstr3_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,129 :: 		Trans_TCP((PTcpStruct) tcpPacket, PckLen, TCPLen);   //(TCPLen + TcpDataLen)
	MOVF        SendMessage_tcpPacket_L0+0, 0 
	MOVWF       FARG_Trans_TCP_TcpData+0 
	MOVF        SendMessage_tcpPacket_L0+1, 0 
	MOVWF       FARG_Trans_TCP_TcpData+1 
	MOVF        _PckLen+0, 0 
	MOVWF       FARG_Trans_TCP_PckLen+0 
	MOVF        _TCPLen+0, 0 
	MOVWF       FARG_Trans_TCP_TCPLen+0 
	MOVF        _TCPLen+1, 0 
	MOVWF       FARG_Trans_TCP_TCPLen+1 
	CALL        _Trans_TCP+0, 0
;PIC_Client.c,130 :: 		}
L_end_SendMessage:
	RETURN      0
; end of _SendMessage

_HandleArpPackage:

;PIC_Client.c,132 :: 		bool HandleArpPackage(PArpStruct arpData) {
;PIC_Client.c,133 :: 		UART1_Write_Text("\n\rARP Pakke. ");
	MOVLW       ?lstr4_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,134 :: 		if (arpData->arp.HwType == 0x0100 && // HwType = 0001
	MOVLW       14
	ADDWF       FARG_HandleArpPackage_arpData+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_HandleArpPackage_arpData+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
;PIC_Client.c,135 :: 		arpData->arp.PrType == 0x0008 && // PrType = 0x0800
	MOVF        R2, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__HandleArpPackage292
	MOVLW       0
	XORWF       R1, 0 
L__HandleArpPackage292:
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleArpPackage24
	MOVLW       14
	ADDWF       FARG_HandleArpPackage_arpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleArpPackage_arpData+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__HandleArpPackage293
	MOVLW       8
	XORWF       R1, 0 
L__HandleArpPackage293:
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleArpPackage24
;PIC_Client.c,136 :: 		arpData->arp.HwLen == 0x06 && arpData->arp.PrLen == 0x04 &&
	MOVLW       14
	ADDWF       FARG_HandleArpPackage_arpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleArpPackage_arpData+1, 0 
	MOVWF       R1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       6
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleArpPackage24
	MOVLW       14
	ADDWF       FARG_HandleArpPackage_arpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleArpPackage_arpData+1, 0 
	MOVWF       R1 
	MOVLW       5
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleArpPackage24
;PIC_Client.c,137 :: 		arpData->arp.OpCode == 0x0100 &&
	MOVLW       14
	ADDWF       FARG_HandleArpPackage_arpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleArpPackage_arpData+1, 0 
	MOVWF       R1 
	MOVLW       6
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__HandleArpPackage294
	MOVLW       0
	XORWF       R1, 0 
L__HandleArpPackage294:
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleArpPackage24
;PIC_Client.c,138 :: 		IsThisDevice(arpData->arp.TIpAddr)) {
	MOVLW       14
	ADDWF       FARG_HandleArpPackage_arpData+0, 0 
	MOVWF       FARG_IsThisDevice_ipAddr+0 
	MOVLW       0
	ADDWFC      FARG_HandleArpPackage_arpData+1, 0 
	MOVWF       FARG_IsThisDevice_ipAddr+1 
	MOVLW       24
	ADDWF       FARG_IsThisDevice_ipAddr+0, 1 
	MOVLW       0
	ADDWFC      FARG_IsThisDevice_ipAddr+1, 1 
	CALL        _IsThisDevice+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_HandleArpPackage24
L__HandleArpPackage280:
;PIC_Client.c,139 :: 		Arp((PArpStruct) arpData, PckLen);
	MOVF        FARG_HandleArpPackage_arpData+0, 0 
	MOVWF       FARG_Arp_PArpData+0 
	MOVF        FARG_HandleArpPackage_arpData+1, 0 
	MOVWF       FARG_Arp_PArpData+1 
	MOVF        _PckLen+0, 0 
	MOVWF       FARG_Arp_PckLen+0 
	CALL        _Arp+0, 0
;PIC_Client.c,140 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_HandleArpPackage
;PIC_Client.c,141 :: 		}
L_HandleArpPackage24:
;PIC_Client.c,143 :: 		return false;
	CLRF        R0 
;PIC_Client.c,145 :: 		}
L_end_HandleArpPackage:
	RETURN      0
; end of _HandleArpPackage

_HandleUdpPackage:

;PIC_Client.c,147 :: 		void HandleUdpPackage(PUdpStruct udpData)
;PIC_Client.c,150 :: 		UART1_Write_Text("UDP Pakke!!!\n\r");
	MOVLW       ?lstr5_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr5_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,151 :: 		if (Udp_Rec((PUdpStruct) UdpData, PckLen)) {
	MOVF        FARG_HandleUdpPackage_udpData+0, 0 
	MOVWF       FARG_Udp_Rec_PUdpData+0 
	MOVF        FARG_HandleUdpPackage_udpData+1, 0 
	MOVWF       FARG_Udp_Rec_PUdpData+1 
	MOVF        _PckLen+0, 0 
	MOVWF       FARG_Udp_Rec_PckLen+0 
	CALL        _Udp_Rec+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_HandleUdpPackage26
;PIC_Client.c,152 :: 		pseudoData = (PPseudoStruct) PseudoPacket;
	MOVLW       _PseudoPacket+0
	MOVWF       HandleUdpPackage_pseudoData_L0+0 
	MOVLW       hi_addr(_PseudoPacket+0)
	MOVWF       HandleUdpPackage_pseudoData_L0+1 
;PIC_Client.c,153 :: 		udp_CheckSum(pseudoData, (PUdpStruct) UdpData);
	MOVF        HandleUdpPackage_pseudoData_L0+0, 0 
	MOVWF       FARG_Udp_CheckSum_UdpPseudoData+0 
	MOVF        HandleUdpPackage_pseudoData_L0+1, 0 
	MOVWF       FARG_Udp_CheckSum_UdpPseudoData+1 
	MOVF        FARG_HandleUdpPackage_udpData+0, 0 
	MOVWF       FARG_Udp_CheckSum_UdpData+0 
	MOVF        FARG_HandleUdpPackage_udpData+1, 0 
	MOVWF       FARG_Udp_CheckSum_UdpData+1 
	CALL        _Udp_CheckSum+0, 0
;PIC_Client.c,154 :: 		Udp_Trans((PUdpStruct) UdpData, PckLen);
	MOVF        FARG_HandleUdpPackage_udpData+0, 0 
	MOVWF       FARG_Udp_Trans_PUdpData+0 
	MOVF        FARG_HandleUdpPackage_udpData+1, 0 
	MOVWF       FARG_Udp_Trans_PUdpData+1 
	MOVF        _PckLen+0, 0 
	MOVWF       FARG_Udp_Trans_PckLen+0 
	CALL        _Udp_Trans+0, 0
;PIC_Client.c,155 :: 		}
L_HandleUdpPackage26:
;PIC_Client.c,156 :: 		}
L_end_HandleUdpPackage:
	RETURN      0
; end of _HandleUdpPackage

_HandleTcpPackage:

;PIC_Client.c,158 :: 		void HandleTcpPackage(PTcpStruct tcpData)
;PIC_Client.c,163 :: 		UART1_Write_Text("TCP Pakke modtaget\n\r");
	MOVLW       ?lstr6_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr6_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,164 :: 		if (tcpData->tcp.DestPort == 0x8D13) //Port TCP port 5005 0x138D
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	XORLW       141
	BTFSS       STATUS+0, 2 
	GOTO        L__HandleTcpPackage297
	MOVLW       19
	XORWF       R1, 0 
L__HandleTcpPackage297:
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleTcpPackage27
;PIC_Client.c,166 :: 		UART1_Write_Text("TCP Pakke modtaget port 5005\n\r");
	MOVLW       ?lstr7_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr7_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,168 :: 		tcpData = (PTcpStruct) Packet;
	MOVLW       _Packet+0
	MOVWF       FARG_HandleTcpPackage_tcpData+0 
	MOVLW       hi_addr(_Packet+0)
	MOVWF       FARG_HandleTcpPackage_tcpData+1 
;PIC_Client.c,169 :: 		pseudoData = (PPseudoStruct) PseudoPacket;
	MOVLW       _PseudoPacket+0
	MOVWF       HandleTcpPackage_pseudoData_L0+0 
	MOVLW       hi_addr(_PseudoPacket+0)
	MOVWF       HandleTcpPackage_pseudoData_L0+1 
;PIC_Client.c,170 :: 		Tcp_CheckSum((PPseudoStruct) pseudoData, (PTcpStruct) tcpData);
	MOVF        HandleTcpPackage_pseudoData_L0+0, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpPseudoData+0 
	MOVF        HandleTcpPackage_pseudoData_L0+1, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpPseudoData+1 
	MOVF        FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpData+0 
	MOVF        FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpData+1 
	CALL        _Tcp_CheckSum+0, 0
;PIC_Client.c,172 :: 		TCPFlags.byte = tcpData->tcp.Flags.byte;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       13
	ADDWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       R3 
	MOVFF       R2, FSR0
	MOVFF       R3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _TCPFlags+0 
;PIC_Client.c,173 :: 		tcpData->tcp.Flags.byte = 0;
	MOVFF       R2, FSR1
	MOVFF       R3, FSR1H
	CLRF        POSTINC1+0 
;PIC_Client.c,175 :: 		if (TCPFlags.byte == SYN) {
	MOVF        _TCPFlags+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleTcpPackage28
;PIC_Client.c,176 :: 		UART1_Write_Text("TCP SYN Pakke modtaget\n\r");
	MOVLW       ?lstr8_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr8_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,177 :: 		TCP_Ack_Num = tcpData->tcp.SeqNumber;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _TCP_Ack_Num+0 
	MOVF        R1, 0 
	MOVWF       _TCP_Ack_Num+1 
	MOVF        R2, 0 
	MOVWF       _TCP_Ack_Num+2 
	MOVF        R3, 0 
	MOVWF       _TCP_Ack_Num+3 
;PIC_Client.c,178 :: 		TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
	MOVF        R0, 0 
	MOVWF       FARG_swapByteOrder_ui+0 
	MOVF        R1, 0 
	MOVWF       FARG_swapByteOrder_ui+1 
	MOVF        R2, 0 
	MOVWF       FARG_swapByteOrder_ui+2 
	MOVF        R3, 0 
	MOVWF       FARG_swapByteOrder_ui+3 
	CALL        _swapByteOrder+0, 0
	MOVF        R0, 0 
	MOVWF       _TCP_Ack_Num+0 
	MOVF        R1, 0 
	MOVWF       _TCP_Ack_Num+1 
	MOVF        R2, 0 
	MOVWF       _TCP_Ack_Num+2 
	MOVF        R3, 0 
	MOVWF       _TCP_Ack_Num+3 
;PIC_Client.c,179 :: 		TCP_Ack_Num++;
	MOVLW       1
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	ADDWFC      R2, 1 
	ADDWFC      R3, 1 
	MOVF        R0, 0 
	MOVWF       _TCP_Ack_Num+0 
	MOVF        R1, 0 
	MOVWF       _TCP_Ack_Num+1 
	MOVF        R2, 0 
	MOVWF       _TCP_Ack_Num+2 
	MOVF        R3, 0 
	MOVWF       _TCP_Ack_Num+3 
;PIC_Client.c,180 :: 		TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
	MOVF        R0, 0 
	MOVWF       FARG_swapByteOrder_ui+0 
	MOVF        R1, 0 
	MOVWF       FARG_swapByteOrder_ui+1 
	MOVF        R2, 0 
	MOVWF       FARG_swapByteOrder_ui+2 
	MOVF        R3, 0 
	MOVWF       FARG_swapByteOrder_ui+3 
	CALL        _swapByteOrder+0, 0
	MOVF        R0, 0 
	MOVWF       _TCP_Ack_Num+0 
	MOVF        R1, 0 
	MOVWF       _TCP_Ack_Num+1 
	MOVF        R2, 0 
	MOVWF       _TCP_Ack_Num+2 
	MOVF        R3, 0 
	MOVWF       _TCP_Ack_Num+3 
;PIC_Client.c,181 :: 		tcpData->tcp.AckNumber = TCP_Ack_Num;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R4 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R5 
	MOVLW       8
	ADDWF       R4, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R5, 0 
	MOVWF       FSR1H 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,183 :: 		tcpData->tcp.SeqNumber = 0x78563412; //0x12345678
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       18
	MOVWF       POSTINC1+0 
	MOVLW       52
	MOVWF       POSTINC1+0 
	MOVLW       86
	MOVWF       POSTINC1+0 
	MOVLW       120
	MOVWF       POSTINC1+0 
;PIC_Client.c,185 :: 		tcpData->tcp.Flags.bits.flagSYN = 1;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       13
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 1 
;PIC_Client.c,186 :: 		tcpData->tcp.Flags.bits.flagACK = 1;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       13
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 4 
;PIC_Client.c,188 :: 		TCPLen = tcpData->tcp.DataOffset.Val * 4;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       240
	ANDWF       R0, 0 
	MOVWF       R3 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	RLCF        R1, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	RLCF        R1, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	MOVWF       _TCPLen+0 
	MOVF        R1, 0 
	MOVWF       _TCPLen+1 
;PIC_Client.c,189 :: 		Trans_TCP((PTcpStruct) tcpData, PckLen, TCPLen);
	MOVF        FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FARG_Trans_TCP_TcpData+0 
	MOVF        FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FARG_Trans_TCP_TcpData+1 
	MOVF        _PckLen+0, 0 
	MOVWF       FARG_Trans_TCP_PckLen+0 
	MOVF        R0, 0 
	MOVWF       FARG_Trans_TCP_TCPLen+0 
	MOVF        R1, 0 
	MOVWF       FARG_Trans_TCP_TCPLen+1 
	CALL        _Trans_TCP+0, 0
;PIC_Client.c,191 :: 		UART1_Write_Text("TCP SYN Pakke sendt\n\r");
	MOVLW       ?lstr9_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr9_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,192 :: 		} else if (TCPFlags.byte == PSHACK) {
	GOTO        L_HandleTcpPackage29
L_HandleTcpPackage28:
	MOVF        _TCPFlags+0, 0 
	XORLW       24
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleTcpPackage30
;PIC_Client.c,195 :: 		UART1_Write_Text("TCP ACK DataPakke modtaget\n\r");
	MOVLW       ?lstr10_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr10_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,197 :: 		DataLen = _SWAP((tcpData->ip.PktLen));
	MOVLW       14
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVF        POSTINC0+0, 0 
	MOVWF       R6 
	MOVF        R6, 0 
	MOVWF       R3 
	CLRF        R4 
	MOVF        R5, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	IORWF       R3, 0 
	MOVWF       R5 
	MOVF        R4, 0 
	IORWF       R1, 0 
	MOVWF       R6 
;PIC_Client.c,198 :: 		TCPDataLen = DataLen - ((tcpData->tcp.DataOffset.Val * 4) + 20);
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       240
	ANDWF       R0, 0 
	MOVWF       R3 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	RLCF        R1, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	RLCF        R1, 1 
	BCF         R0, 0 
	MOVLW       20
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	SUBWF       R5, 0 
	MOVWF       R0 
	MOVF        R1, 0 
	SUBWFB      R6, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _TCPDataLen+0 
	MOVF        R1, 0 
	MOVWF       _TCPDataLen+1 
;PIC_Client.c,199 :: 		if (TCPDataLen) {
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_HandleTcpPackage31
;PIC_Client.c,200 :: 		TCP_Ack_Num = tcpData->tcp.SeqNumber;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _TCP_Ack_Num+0 
	MOVF        R1, 0 
	MOVWF       _TCP_Ack_Num+1 
	MOVF        R2, 0 
	MOVWF       _TCP_Ack_Num+2 
	MOVF        R3, 0 
	MOVWF       _TCP_Ack_Num+3 
;PIC_Client.c,201 :: 		TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
	MOVF        R0, 0 
	MOVWF       FARG_swapByteOrder_ui+0 
	MOVF        R1, 0 
	MOVWF       FARG_swapByteOrder_ui+1 
	MOVF        R2, 0 
	MOVWF       FARG_swapByteOrder_ui+2 
	MOVF        R3, 0 
	MOVWF       FARG_swapByteOrder_ui+3 
	CALL        _swapByteOrder+0, 0
	MOVF        R0, 0 
	MOVWF       _TCP_Ack_Num+0 
	MOVF        R1, 0 
	MOVWF       _TCP_Ack_Num+1 
	MOVF        R2, 0 
	MOVWF       _TCP_Ack_Num+2 
	MOVF        R3, 0 
	MOVWF       _TCP_Ack_Num+3 
;PIC_Client.c,202 :: 		TCP_Ack_Num += TCPDataLen;
	MOVF        _TCPDataLen+0, 0 
	ADDWF       R0, 1 
	MOVF        _TCPDataLen+1, 0 
	ADDWFC      R1, 1 
	MOVLW       0
	ADDWFC      R2, 1 
	ADDWFC      R3, 1 
	MOVF        R0, 0 
	MOVWF       _TCP_Ack_Num+0 
	MOVF        R1, 0 
	MOVWF       _TCP_Ack_Num+1 
	MOVF        R2, 0 
	MOVWF       _TCP_Ack_Num+2 
	MOVF        R3, 0 
	MOVWF       _TCP_Ack_Num+3 
;PIC_Client.c,203 :: 		sequenceNumber = TCP_Ack_Num;
	MOVF        R0, 0 
	MOVWF       _sequenceNumber+0 
	MOVF        R1, 0 
	MOVWF       _sequenceNumber+1 
	MOVF        R2, 0 
	MOVWF       _sequenceNumber+2 
	MOVF        R3, 0 
	MOVWF       _sequenceNumber+3 
;PIC_Client.c,204 :: 		sprintf(buffer, "%d", sequenceNumber);
	MOVLW       HandleTcpPackage_buffer_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(HandleTcpPackage_buffer_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_11_PIC_Client+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_11_PIC_Client+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_11_PIC_Client+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        R0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        R1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        R2, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVF        R3, 0 
	MOVWF       FARG_sprintf_wh+8 
	CALL        _sprintf+0, 0
;PIC_Client.c,205 :: 		UART1_Write_Text("\n\rSequence: ");
	MOVLW       ?lstr12_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr12_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,206 :: 		UART1_Write_Text(buffer);
	MOVLW       HandleTcpPackage_buffer_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(HandleTcpPackage_buffer_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,207 :: 		UART1_Write_Text("\n\r");
	MOVLW       ?lstr13_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr13_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,209 :: 		TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
	MOVF        _TCP_Ack_Num+0, 0 
	MOVWF       FARG_swapByteOrder_ui+0 
	MOVF        _TCP_Ack_Num+1, 0 
	MOVWF       FARG_swapByteOrder_ui+1 
	MOVF        _TCP_Ack_Num+2, 0 
	MOVWF       FARG_swapByteOrder_ui+2 
	MOVF        _TCP_Ack_Num+3, 0 
	MOVWF       FARG_swapByteOrder_ui+3 
	CALL        _swapByteOrder+0, 0
	MOVF        R0, 0 
	MOVWF       _TCP_Ack_Num+0 
	MOVF        R1, 0 
	MOVWF       _TCP_Ack_Num+1 
	MOVF        R2, 0 
	MOVWF       _TCP_Ack_Num+2 
	MOVF        R3, 0 
	MOVWF       _TCP_Ack_Num+3 
;PIC_Client.c,211 :: 		sprintf(buffer, "%d", sequenceNumber);
	MOVLW       HandleTcpPackage_buffer_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(HandleTcpPackage_buffer_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_14_PIC_Client+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_14_PIC_Client+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_14_PIC_Client+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        _sequenceNumber+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _sequenceNumber+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        _sequenceNumber+2, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVF        _sequenceNumber+3, 0 
	MOVWF       FARG_sprintf_wh+8 
	CALL        _sprintf+0, 0
;PIC_Client.c,212 :: 		UART1_Write_Text("\n\rAfter: ");
	MOVLW       ?lstr15_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr15_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,213 :: 		UART1_Write_Text(buffer);
	MOVLW       HandleTcpPackage_buffer_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(HandleTcpPackage_buffer_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,214 :: 		UART1_Write_Text("\n\r");
	MOVLW       ?lstr16_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr16_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,216 :: 		tcpData->tcp.SeqNumber = tcpData->tcp.AckNumber;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       8
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,217 :: 		tcpData->tcp.AckNumber = TCP_Ack_Num;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       8
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _TCP_Ack_Num+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        _TCP_Ack_Num+1, 0 
	MOVWF       POSTINC1+0 
	MOVF        _TCP_Ack_Num+2, 0 
	MOVWF       POSTINC1+0 
	MOVF        _TCP_Ack_Num+3, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,219 :: 		tcpData->tcp.Flags.bits.flagACK = 1;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       13
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 4 
;PIC_Client.c,221 :: 		UART1_Write_Text("\n\r");
	MOVLW       ?lstr17_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr17_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,223 :: 		UART1_Write_Text(tcpData->uddata);
	MOVLW       54
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,224 :: 		UART1_Write_Text("\n\r");
	MOVLW       ?lstr18_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr18_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,226 :: 		for (i = 0; i <= TCPDataLen; i++) {
	CLRF        HandleTcpPackage_i_L2+0 
L_HandleTcpPackage32:
	MOVLW       0
	SUBWF       _TCPDataLen+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__HandleTcpPackage298
	MOVF        HandleTcpPackage_i_L2+0, 0 
	SUBWF       _TCPDataLen+0, 0 
L__HandleTcpPackage298:
	BTFSS       STATUS+0, 0 
	GOTO        L_HandleTcpPackage33
;PIC_Client.c,227 :: 		if (tcpData->uddata[i] > 'a' && tcpData->uddata[i] < 'z')
	MOVLW       54
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVF        HandleTcpPackage_i_L2+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       97
	BTFSC       STATUS+0, 0 
	GOTO        L_HandleTcpPackage37
	MOVLW       54
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVF        HandleTcpPackage_i_L2+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVLW       122
	SUBWF       POSTINC0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_HandleTcpPackage37
L__HandleTcpPackage281:
;PIC_Client.c,228 :: 		tcpData->uddata[i].B5 = 0;
	MOVLW       54
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVF        HandleTcpPackage_i_L2+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	BCF         POSTINC1+0, 5 
L_HandleTcpPackage37:
;PIC_Client.c,226 :: 		for (i = 0; i <= TCPDataLen; i++) {
	INCF        HandleTcpPackage_i_L2+0, 1 
;PIC_Client.c,229 :: 		}
	GOTO        L_HandleTcpPackage32
L_HandleTcpPackage33:
;PIC_Client.c,230 :: 		tcpData->uddata[TCPDataLen] = 0;
	MOVLW       54
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVF        _TCPDataLen+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVF        _TCPDataLen+1, 0 
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,232 :: 		UART1_Write_Text(tcpData->uddata);
	MOVLW       54
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,234 :: 		TCPLen = tcpData->tcp.DataOffset.Val * 4;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       240
	ANDWF       R0, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	BCF         R1, 7 
	MOVF        R1, 0 
	MOVWF       _TCPLen+0 
	MOVLW       0
	MOVWF       _TCPLen+1 
	RLCF        _TCPLen+0, 1 
	RLCF        _TCPLen+1, 1 
	BCF         _TCPLen+0, 0 
	RLCF        _TCPLen+0, 1 
	RLCF        _TCPLen+1, 1 
	BCF         _TCPLen+0, 0 
;PIC_Client.c,236 :: 		pseudoData = (PPseudoStruct) PseudoPacket;
	MOVLW       _PseudoPacket+0
	MOVWF       HandleTcpPackage_pseudoData_L0+0 
	MOVLW       hi_addr(_PseudoPacket+0)
	MOVWF       HandleTcpPackage_pseudoData_L0+1 
;PIC_Client.c,237 :: 		Tcp_CheckSum((PPseudoStruct) pseudoData, (PTcpStruct) tcpData);
	MOVF        HandleTcpPackage_pseudoData_L0+0, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpPseudoData+0 
	MOVF        HandleTcpPackage_pseudoData_L0+1, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpPseudoData+1 
	MOVF        FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpData+0 
	MOVF        FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpData+1 
	CALL        _Tcp_CheckSum+0, 0
;PIC_Client.c,238 :: 		Trans_TCP((PTcpStruct) tcpData, PckLen, (TCPLen + TcpDataLen));
	MOVF        FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FARG_Trans_TCP_TcpData+0 
	MOVF        FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FARG_Trans_TCP_TcpData+1 
	MOVF        _PckLen+0, 0 
	MOVWF       FARG_Trans_TCP_PckLen+0 
	MOVF        _TCPDataLen+0, 0 
	ADDWF       _TCPLen+0, 0 
	MOVWF       FARG_Trans_TCP_TCPLen+0 
	MOVF        _TCPDataLen+1, 0 
	ADDWFC      _TCPLen+1, 0 
	MOVWF       FARG_Trans_TCP_TCPLen+1 
	CALL        _Trans_TCP+0, 0
;PIC_Client.c,240 :: 		UART1_Write_Text("\n\rTCP ACK Pakke sendt\n\r");
	MOVLW       ?lstr19_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr19_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,241 :: 		}
L_HandleTcpPackage31:
;PIC_Client.c,243 :: 		UART1_Write_Text("\n\rGemmer data");
	MOVLW       ?lstr20_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr20_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,244 :: 		destinationPort = tcpData->tcp.SourcePort;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _destinationPort+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       _destinationPort+1 
;PIC_Client.c,246 :: 		memcpy(destinationMac, tcpData->eth.ScrMac, 6);
	MOVLW       _destinationMac+0
	MOVWF       FARG_memcpy_d1+0 
	MOVLW       hi_addr(_destinationMac+0)
	MOVWF       FARG_memcpy_d1+1 
	MOVLW       6
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FARG_memcpy_s1+0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FARG_memcpy_s1+1 
	MOVLW       6
	MOVWF       FARG_memcpy_n+0 
	MOVLW       0
	MOVWF       FARG_memcpy_n+1 
	CALL        _memcpy+0, 0
;PIC_Client.c,247 :: 		memcpy(destinationIp, tcpData->ip.ScrAddr, 4);
	MOVLW       _destinationIp+0
	MOVWF       FARG_memcpy_d1+0 
	MOVLW       hi_addr(_destinationIp+0)
	MOVWF       FARG_memcpy_d1+1 
	MOVLW       14
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FARG_memcpy_s1+0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FARG_memcpy_s1+1 
	MOVLW       12
	ADDWF       FARG_memcpy_s1+0, 1 
	MOVLW       0
	ADDWFC      FARG_memcpy_s1+1, 1 
	MOVLW       4
	MOVWF       FARG_memcpy_n+0 
	MOVLW       0
	MOVWF       FARG_memcpy_n+1 
	CALL        _memcpy+0, 0
;PIC_Client.c,249 :: 		} else if (TCPFlags.byte == FINACK) {
	GOTO        L_HandleTcpPackage38
L_HandleTcpPackage30:
	MOVF        _TCPFlags+0, 0 
	XORLW       17
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleTcpPackage39
;PIC_Client.c,250 :: 		UART1_Write_Text("TCP FIN ACK Pakke modtaget\n\r");
	MOVLW       ?lstr21_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr21_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,251 :: 		TCP_Ack_Num = tcpData->tcp.SeqNumber;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _TCP_Ack_Num+0 
	MOVF        R1, 0 
	MOVWF       _TCP_Ack_Num+1 
	MOVF        R2, 0 
	MOVWF       _TCP_Ack_Num+2 
	MOVF        R3, 0 
	MOVWF       _TCP_Ack_Num+3 
;PIC_Client.c,252 :: 		TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
	MOVF        R0, 0 
	MOVWF       FARG_swapByteOrder_ui+0 
	MOVF        R1, 0 
	MOVWF       FARG_swapByteOrder_ui+1 
	MOVF        R2, 0 
	MOVWF       FARG_swapByteOrder_ui+2 
	MOVF        R3, 0 
	MOVWF       FARG_swapByteOrder_ui+3 
	CALL        _swapByteOrder+0, 0
	MOVF        R0, 0 
	MOVWF       _TCP_Ack_Num+0 
	MOVF        R1, 0 
	MOVWF       _TCP_Ack_Num+1 
	MOVF        R2, 0 
	MOVWF       _TCP_Ack_Num+2 
	MOVF        R3, 0 
	MOVWF       _TCP_Ack_Num+3 
;PIC_Client.c,253 :: 		TCP_Ack_Num++;
	MOVLW       1
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	ADDWFC      R2, 1 
	ADDWFC      R3, 1 
	MOVF        R0, 0 
	MOVWF       _TCP_Ack_Num+0 
	MOVF        R1, 0 
	MOVWF       _TCP_Ack_Num+1 
	MOVF        R2, 0 
	MOVWF       _TCP_Ack_Num+2 
	MOVF        R3, 0 
	MOVWF       _TCP_Ack_Num+3 
;PIC_Client.c,254 :: 		TCP_Ack_num = SwapByteOrder(TCP_Ack_Num);
	MOVF        R0, 0 
	MOVWF       FARG_swapByteOrder_ui+0 
	MOVF        R1, 0 
	MOVWF       FARG_swapByteOrder_ui+1 
	MOVF        R2, 0 
	MOVWF       FARG_swapByteOrder_ui+2 
	MOVF        R3, 0 
	MOVWF       FARG_swapByteOrder_ui+3 
	CALL        _swapByteOrder+0, 0
	MOVF        R0, 0 
	MOVWF       _TCP_Ack_Num+0 
	MOVF        R1, 0 
	MOVWF       _TCP_Ack_Num+1 
	MOVF        R2, 0 
	MOVWF       _TCP_Ack_Num+2 
	MOVF        R3, 0 
	MOVWF       _TCP_Ack_Num+3 
;PIC_Client.c,256 :: 		tcpData->tcp.SeqNumber = tcpData->tcp.AckNumber;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       8
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,257 :: 		tcpData->tcp.AckNumber = TCP_Ack_Num;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       8
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _TCP_Ack_Num+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        _TCP_Ack_Num+1, 0 
	MOVWF       POSTINC1+0 
	MOVF        _TCP_Ack_Num+2, 0 
	MOVWF       POSTINC1+0 
	MOVF        _TCP_Ack_Num+3, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,259 :: 		tcpData->tcp.Flags.bits.flagACK = 1;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       13
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 4 
;PIC_Client.c,260 :: 		tcpData->tcp.Flags.bits.flagFIN = 1;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       13
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 0 
;PIC_Client.c,262 :: 		TCPLen = tcpData->tcp.DataOffset.Val * 4;
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       240
	ANDWF       R0, 0 
	MOVWF       R3 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	RLCF        R1, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	RLCF        R1, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	MOVWF       _TCPLen+0 
	MOVF        R1, 0 
	MOVWF       _TCPLen+1 
;PIC_Client.c,263 :: 		Trans_TCP((PTcpStruct) tcpData, PckLen, TCPLen);
	MOVF        FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FARG_Trans_TCP_TcpData+0 
	MOVF        FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FARG_Trans_TCP_TcpData+1 
	MOVF        _PckLen+0, 0 
	MOVWF       FARG_Trans_TCP_PckLen+0 
	MOVF        R0, 0 
	MOVWF       FARG_Trans_TCP_TCPLen+0 
	MOVF        R1, 0 
	MOVWF       FARG_Trans_TCP_TCPLen+1 
	CALL        _Trans_TCP+0, 0
;PIC_Client.c,264 :: 		UART1_Write_Text("TCP ACK - FIN Pakke sendt\n\r");
	MOVLW       ?lstr22_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr22_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,265 :: 		}
L_HandleTcpPackage39:
L_HandleTcpPackage38:
L_HandleTcpPackage29:
;PIC_Client.c,266 :: 		}
L_HandleTcpPackage27:
;PIC_Client.c,267 :: 		}
L_end_HandleTcpPackage:
	RETURN      0
; end of _HandleTcpPackage

_IsThisDevice:

;PIC_Client.c,269 :: 		bool IsThisDevice(unsigned short ipAddr[])
;PIC_Client.c,272 :: 		ipAddr[1] == MyIpAddr[1] &&
	MOVFF       FARG_IsThisDevice_ipAddr+0, FSR0
	MOVFF       FARG_IsThisDevice_ipAddr+1, FSR0H
	MOVF        POSTINC0+0, 0 
	XORWF       _myIpAddr+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_IsThisDevice42
	MOVLW       1
	ADDWF       FARG_IsThisDevice_ipAddr+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_IsThisDevice_ipAddr+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORWF       _myIpAddr+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_IsThisDevice42
;PIC_Client.c,273 :: 		ipAddr[2] == MyIpAddr[2] &&
	MOVLW       2
	ADDWF       FARG_IsThisDevice_ipAddr+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_IsThisDevice_ipAddr+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORWF       _myIpAddr+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_IsThisDevice42
;PIC_Client.c,274 :: 		ipAddr[3] == MyIpAddr[3])
	MOVLW       3
	ADDWF       FARG_IsThisDevice_ipAddr+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_IsThisDevice_ipAddr+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORWF       _myIpAddr+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_IsThisDevice42
L__IsThisDevice282:
;PIC_Client.c,276 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_IsThisDevice
;PIC_Client.c,277 :: 		}
L_IsThisDevice42:
;PIC_Client.c,280 :: 		return false;
	CLRF        R0 
;PIC_Client.c,282 :: 		}
L_end_IsThisDevice:
	RETURN      0
; end of _IsThisDevice

_Tcp_CheckSum:

;PIC_Client.c,284 :: 		unsigned int Tcp_CheckSum(PPseudoStruct TcpPseudoData, PTcpStruct TcpData) {
;PIC_Client.c,290 :: 		DataLen = _SWAP(TcpData->ip.PktLen);
	MOVLW       14
	ADDWF       FARG_Tcp_CheckSum_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Tcp_CheckSum_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVF        POSTINC0+0, 0 
	MOVWF       R6 
	MOVF        R6, 0 
	MOVWF       R3 
	CLRF        R4 
	MOVF        R5, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	IORWF       R3, 0 
	MOVWF       R6 
	MOVF        R4, 0 
	IORWF       R1, 0 
	MOVWF       R7 
;PIC_Client.c,291 :: 		TCPDataLen = DataLen - ((TcpData->tcp.DataOffset.Val * 4) + 20);
	MOVLW       34
	ADDWF       FARG_Tcp_CheckSum_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Tcp_CheckSum_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       R4 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       R5 
	MOVFF       R4, FSR0
	MOVFF       R5, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       240
	ANDWF       R0, 0 
	MOVWF       R3 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	RLCF        R1, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	RLCF        R1, 1 
	BCF         R0, 0 
	MOVLW       20
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	SUBWF       R6, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	SUBWFB      R7, 0 
	MOVWF       R3 
;PIC_Client.c,293 :: 		TcpHdrLen = (TcpData->tcp.DataOffset.Val * 4) + TCPDataLen;
	MOVFF       R4, FSR0
	MOVFF       R5, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       240
	ANDWF       R0, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	BCF         R1, 7 
	MOVF        R1, 0 
	MOVWF       Tcp_CheckSum_TcpHdrLen_L0+0 
	MOVLW       0
	MOVWF       Tcp_CheckSum_TcpHdrLen_L0+1 
	RLCF        Tcp_CheckSum_TcpHdrLen_L0+0, 1 
	RLCF        Tcp_CheckSum_TcpHdrLen_L0+1, 1 
	BCF         Tcp_CheckSum_TcpHdrLen_L0+0, 0 
	RLCF        Tcp_CheckSum_TcpHdrLen_L0+0, 1 
	RLCF        Tcp_CheckSum_TcpHdrLen_L0+1, 1 
	BCF         Tcp_CheckSum_TcpHdrLen_L0+0, 0 
	MOVF        R2, 0 
	ADDWF       Tcp_CheckSum_TcpHdrLen_L0+0, 1 
	MOVF        R3, 0 
	ADDWFC      Tcp_CheckSum_TcpHdrLen_L0+1, 1 
;PIC_Client.c,295 :: 		for (i = 0; i <= 3; i++) {
	CLRF        Tcp_CheckSum_i_L0+0 
L_Tcp_CheckSum44:
	MOVF        Tcp_CheckSum_i_L0+0, 0 
	SUBLW       3
	BTFSS       STATUS+0, 0 
	GOTO        L_Tcp_CheckSum45
;PIC_Client.c,296 :: 		TcpPseudoData->SrcIP[i] = TcpData->ip.ScrAddr[i];
	MOVF        Tcp_CheckSum_i_L0+0, 0 
	ADDWF       FARG_Tcp_CheckSum_TcpPseudoData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Tcp_CheckSum_TcpPseudoData+1, 0 
	MOVWF       FSR1H 
	MOVLW       14
	ADDWF       FARG_Tcp_CheckSum_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Tcp_CheckSum_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       12
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        Tcp_CheckSum_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,297 :: 		TcpPseudoData->DestIP[i] = TcpData->ip.DestAddr[i];
	MOVLW       4
	ADDWF       FARG_Tcp_CheckSum_TcpPseudoData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Tcp_CheckSum_TcpPseudoData+1, 0 
	MOVWF       R1 
	MOVF        Tcp_CheckSum_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       14
	ADDWF       FARG_Tcp_CheckSum_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Tcp_CheckSum_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       16
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        Tcp_CheckSum_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,295 :: 		for (i = 0; i <= 3; i++) {
	INCF        Tcp_CheckSum_i_L0+0, 1 
;PIC_Client.c,298 :: 		}
	GOTO        L_Tcp_CheckSum44
L_Tcp_CheckSum45:
;PIC_Client.c,299 :: 		TcpPseudoData->Zero = 0;
	MOVLW       8
	ADDWF       FARG_Tcp_CheckSum_TcpPseudoData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Tcp_CheckSum_TcpPseudoData+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,300 :: 		TcpPseudoData->Proto = PROTO_TCP; //TCP
	MOVLW       9
	ADDWF       FARG_Tcp_CheckSum_TcpPseudoData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Tcp_CheckSum_TcpPseudoData+1, 0 
	MOVWF       FSR1H 
	MOVLW       6
	MOVWF       POSTINC1+0 
;PIC_Client.c,301 :: 		TcpPseudoData->DataLen = _SWAP(TcpHdrLen);
	MOVLW       10
	ADDWF       FARG_Tcp_CheckSum_TcpPseudoData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Tcp_CheckSum_TcpPseudoData+1, 0 
	MOVWF       FSR1H 
	MOVF        Tcp_CheckSum_TcpHdrLen_L0+1, 0 
	MOVWF       R3 
	CLRF        R4 
	MOVF        Tcp_CheckSum_TcpHdrLen_L0+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R3, 0 
	IORWF       R0, 1 
	MOVF        R4, 0 
	IORWF       R1, 1 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,303 :: 		UdPacket((unsigned short * ) TcpPseudoData, 12);
	MOVF        FARG_Tcp_CheckSum_TcpPseudoData+0, 0 
	MOVWF       FARG_UdPacket_Data+0 
	MOVF        FARG_Tcp_CheckSum_TcpPseudoData+1, 0 
	MOVWF       FARG_UdPacket_Data+1 
	MOVLW       12
	MOVWF       FARG_UdPacket_len+0 
	MOVLW       0
	MOVWF       FARG_UdPacket_len+1 
	CALL        _UdPacket+0, 0
;PIC_Client.c,304 :: 		UART1_Write_Text("TCP pseudo Trans Pakke\n\r");
	MOVLW       ?lstr23_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr23_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,306 :: 		TcpCkSum = Cksum(UDASTART, 12, 0); //Tcp Pseudo checksum seed = 0
	MOVLW       82
	MOVWF       FARG_CkSum_offset+0 
	MOVLW       6
	MOVWF       FARG_CkSum_offset+1 
	MOVLW       12
	MOVWF       FARG_CkSum_Len+0 
	MOVLW       0
	MOVWF       FARG_CkSum_Len+1 
	CLRF        FARG_CkSum_Seed+0 
	CALL        _CkSum+0, 0
	MOVF        R0, 0 
	MOVWF       Tcp_CheckSum_TcpCkSum_L0+0 
	MOVF        R1, 0 
	MOVWF       Tcp_CheckSum_TcpCkSum_L0+1 
;PIC_Client.c,308 :: 		ShowPacket((unsigned short * ) TcpPseudoData, 22);
	MOVF        FARG_Tcp_CheckSum_TcpPseudoData+0, 0 
	MOVWF       FARG_ShowPacket_Buffer+0 
	MOVF        FARG_Tcp_CheckSum_TcpPseudoData+1, 0 
	MOVWF       FARG_ShowPacket_Buffer+1 
	MOVLW       22
	MOVWF       FARG_ShowPacket_len+0 
	MOVLW       0
	MOVWF       FARG_ShowPacket_len+1 
	CALL        _ShowPacket+0, 0
;PIC_Client.c,309 :: 		return TcpCkSum;
	MOVF        Tcp_CheckSum_TcpCkSum_L0+0, 0 
	MOVWF       R0 
	MOVF        Tcp_CheckSum_TcpCkSum_L0+1, 0 
	MOVWF       R1 
;PIC_Client.c,310 :: 		}
L_end_Tcp_CheckSum:
	RETURN      0
; end of _Tcp_CheckSum

_Trans_TCP:

;PIC_Client.c,313 :: 		void Trans_TCP(PTcpStruct TcpData, unsigned short PckLen, unsigned TCPLen) {
;PIC_Client.c,316 :: 		SwapAddr((PIpStruct) TcpData);
	MOVF        FARG_Trans_TCP_TcpData+0, 0 
	MOVWF       FARG_SwapAddr_IpData+0 
	MOVF        FARG_Trans_TCP_TcpData+1, 0 
	MOVWF       FARG_SwapAddr_IpData+1 
	CALL        _SwapAddr+0, 0
;PIC_Client.c,318 :: 		temp = TcpData->Tcp.SourcePort; // Swap portNr.
	MOVLW       34
	ADDWF       FARG_Trans_TCP_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Trans_TCP_TcpData+1, 0 
	MOVWF       R1 
	MOVFF       R0, FSR0
	MOVFF       R1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       Trans_TCP_temp_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       Trans_TCP_temp_L0+1 
;PIC_Client.c,319 :: 		TcpData->tcp.SourcePort = TcpData->tcp.DestPort;
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVFF       R0, FSR1
	MOVFF       R1, FSR1H
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,320 :: 		TcpData->tcp.DestPort = temp;
	MOVLW       34
	ADDWF       FARG_Trans_TCP_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Trans_TCP_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        Trans_TCP_temp_L0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        Trans_TCP_temp_L0+1, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,322 :: 		TcpData->tcp.Checksum = 0;
	MOVLW       34
	ADDWF       FARG_Trans_TCP_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Trans_TCP_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       16
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;PIC_Client.c,324 :: 		TxPacket((unsigned short * ) TcpData, PckLen, FALSE); //Fill Eth Buffer Don't send
	MOVF        FARG_Trans_TCP_TcpData+0, 0 
	MOVWF       FARG_TxPacket_PkData+0 
	MOVF        FARG_Trans_TCP_TcpData+1, 0 
	MOVWF       FARG_TxPacket_PkData+1 
	MOVF        FARG_Trans_TCP_PckLen+0, 0 
	MOVWF       FARG_TxPacket_len+0 
	MOVLW       0
	MOVWF       FARG_TxPacket_len+1 
	CLRF        FARG_TxPacket_TX+0 
	CALL        _TxPacket+0, 0
;PIC_Client.c,326 :: 		TcpData->tcp.Checksum = CkSum(sizeof(IpStruct), TCPLen, TRUE);; // Checksum with seed
	MOVLW       34
	ADDWF       FARG_Trans_TCP_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Trans_TCP_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       16
	ADDWF       R0, 0 
	MOVWF       FLOC__Trans_TCP+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__Trans_TCP+1 
	MOVLW       34
	MOVWF       FARG_CkSum_offset+0 
	MOVLW       0
	MOVWF       FARG_CkSum_offset+1 
	MOVF        FARG_Trans_TCP_TCPLen+0, 0 
	MOVWF       FARG_CkSum_Len+0 
	MOVF        FARG_Trans_TCP_TCPLen+1, 0 
	MOVWF       FARG_CkSum_Len+1 
	MOVLW       1
	MOVWF       FARG_CkSum_Seed+0 
	CALL        _CkSum+0, 0
	MOVFF       FLOC__Trans_TCP+0, FSR1
	MOVFF       FLOC__Trans_TCP+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,332 :: 		TxPacket((unsigned short * ) TcpData, PckLen, TRUE); //Fill Eth Buffer And send
	MOVF        FARG_Trans_TCP_TcpData+0, 0 
	MOVWF       FARG_TxPacket_PkData+0 
	MOVF        FARG_Trans_TCP_TcpData+1, 0 
	MOVWF       FARG_TxPacket_PkData+1 
	MOVF        FARG_Trans_TCP_PckLen+0, 0 
	MOVWF       FARG_TxPacket_len+0 
	MOVLW       0
	MOVWF       FARG_TxPacket_len+1 
	MOVLW       1
	MOVWF       FARG_TxPacket_TX+0 
	CALL        _TxPacket+0, 0
;PIC_Client.c,333 :: 		}
L_end_Trans_TCP:
	RETURN      0
; end of _Trans_TCP

_Udp_Rec:

;PIC_Client.c,335 :: 		unsigned short Udp_Rec(PUdpStruct PUdpData, unsigned short PckLen) {
;PIC_Client.c,337 :: 		UART1_Write_Text("UDP Pakke modtaget\n\r");
	MOVLW       ?lstr24_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr24_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,338 :: 		if (PUdpData->udp.DestPort == 0x8D13) // Port 5005
	MOVLW       34
	ADDWF       FARG_Udp_Rec_PUdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_Rec_PUdpData+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	XORLW       141
	BTFSS       STATUS+0, 2 
	GOTO        L__Udp_Rec303
	MOVLW       19
	XORWF       R1, 0 
L__Udp_Rec303:
	BTFSS       STATUS+0, 2 
	GOTO        L_Udp_Rec47
;PIC_Client.c,340 :: 		TekstLen = SWAP(PUdpData->udp.Len) - 8; //Tekst længde - UDP Hdr.
	MOVLW       34
	ADDWF       FARG_Udp_Rec_PUdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_Rec_PUdpData+1, 0 
	MOVWF       R1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Swap_input+0 
	CALL        _Swap+0, 0
	MOVLW       8
	SUBWF       R0, 0 
	MOVWF       R2 
;PIC_Client.c,341 :: 		PUdpData->uddata[TekstLen] = 0;
	MOVLW       42
	ADDWF       FARG_Udp_Rec_PUdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_Rec_PUdpData+1, 0 
	MOVWF       R1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,342 :: 		UART1_Write_Text(PUdpData->uddata);
	MOVLW       42
	ADDWF       FARG_Udp_Rec_PUdpData+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       0
	ADDWFC      FARG_Udp_Rec_PUdpData+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,343 :: 		UART1_Write_Text("\n\r");
	MOVLW       ?lstr25_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr25_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,344 :: 		UART1_Write_Text("UDP Pakke modtaget port 5005\n\r");
	MOVLW       ?lstr26_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr26_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,345 :: 		return TRUE;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_Udp_Rec
;PIC_Client.c,346 :: 		} else return FALSE;
L_Udp_Rec47:
	CLRF        R0 
;PIC_Client.c,347 :: 		}
L_end_Udp_Rec:
	RETURN      0
; end of _Udp_Rec

_Udp_CheckSum:

;PIC_Client.c,351 :: 		unsigned int Udp_CheckSum(PPseudoStruct UdpPseudoData, PUdpStruct UdpData) {
;PIC_Client.c,355 :: 		for (i = 0; i <= 3; i++) {
	CLRF        Udp_CheckSum_i_L0+0 
L_Udp_CheckSum49:
	MOVF        Udp_CheckSum_i_L0+0, 0 
	SUBLW       3
	BTFSS       STATUS+0, 0 
	GOTO        L_Udp_CheckSum50
;PIC_Client.c,356 :: 		UdpPseudoData->SrcIP[i] = UdpData->ip.ScrAddr[i];
	MOVF        Udp_CheckSum_i_L0+0, 0 
	ADDWF       FARG_Udp_CheckSum_UdpPseudoData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Udp_CheckSum_UdpPseudoData+1, 0 
	MOVWF       FSR1H 
	MOVLW       14
	ADDWF       FARG_Udp_CheckSum_UdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_CheckSum_UdpData+1, 0 
	MOVWF       R1 
	MOVLW       12
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        Udp_CheckSum_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,357 :: 		UdpPseudoData->DestIP[i] = UdpData->ip.DestAddr[i];
	MOVLW       4
	ADDWF       FARG_Udp_CheckSum_UdpPseudoData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_CheckSum_UdpPseudoData+1, 0 
	MOVWF       R1 
	MOVF        Udp_CheckSum_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       14
	ADDWF       FARG_Udp_CheckSum_UdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_CheckSum_UdpData+1, 0 
	MOVWF       R1 
	MOVLW       16
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        Udp_CheckSum_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,355 :: 		for (i = 0; i <= 3; i++) {
	INCF        Udp_CheckSum_i_L0+0, 1 
;PIC_Client.c,358 :: 		}
	GOTO        L_Udp_CheckSum49
L_Udp_CheckSum50:
;PIC_Client.c,359 :: 		UdpPseudoData->Zero = 0;
	MOVLW       8
	ADDWF       FARG_Udp_CheckSum_UdpPseudoData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Udp_CheckSum_UdpPseudoData+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,360 :: 		UdpPseudoData->Proto = 17; //UDP
	MOVLW       9
	ADDWF       FARG_Udp_CheckSum_UdpPseudoData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Udp_CheckSum_UdpPseudoData+1, 0 
	MOVWF       FSR1H 
	MOVLW       17
	MOVWF       POSTINC1+0 
;PIC_Client.c,361 :: 		UdpPseudoData->DataLen = UdpData->udp.Len;
	MOVLW       10
	ADDWF       FARG_Udp_CheckSum_UdpPseudoData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Udp_CheckSum_UdpPseudoData+1, 0 
	MOVWF       FSR1H 
	MOVLW       34
	ADDWF       FARG_Udp_CheckSum_UdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_CheckSum_UdpData+1, 0 
	MOVWF       R1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,362 :: 		UdPacket((unsigned short * ) UdpPseudoData, 12);
	MOVF        FARG_Udp_CheckSum_UdpPseudoData+0, 0 
	MOVWF       FARG_UdPacket_Data+0 
	MOVF        FARG_Udp_CheckSum_UdpPseudoData+1, 0 
	MOVWF       FARG_UdPacket_Data+1 
	MOVLW       12
	MOVWF       FARG_UdPacket_len+0 
	MOVLW       0
	MOVWF       FARG_UdPacket_len+1 
	CALL        _UdPacket+0, 0
;PIC_Client.c,363 :: 		UART1_Write_Text("UDP pseudo Trans Pakke\n\r");
	MOVLW       ?lstr27_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr27_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,365 :: 		CheckSum = Cksum(UDASTART, 12, 0); //Udp Pseudo checksum seed = 0
	MOVLW       82
	MOVWF       FARG_CkSum_offset+0 
	MOVLW       6
	MOVWF       FARG_CkSum_offset+1 
	MOVLW       12
	MOVWF       FARG_CkSum_Len+0 
	MOVLW       0
	MOVWF       FARG_CkSum_Len+1 
	CLRF        FARG_CkSum_Seed+0 
	CALL        _CkSum+0, 0
	MOVF        R0, 0 
	MOVWF       Udp_CheckSum_CheckSum_L0+0 
	MOVF        R1, 0 
	MOVWF       Udp_CheckSum_CheckSum_L0+1 
;PIC_Client.c,367 :: 		WordToStr(Checksum, HexStr);
	MOVF        R0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _HexStr+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_HexStr+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;PIC_Client.c,368 :: 		UART1_Write_Text("\n\rPseudo Checksum  :");
	MOVLW       ?lstr28_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr28_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,369 :: 		UART1_Write_Text(HexStr);
	MOVLW       _HexStr+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_HexStr+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,370 :: 		UART1_Write_Text("\n\r");
	MOVLW       ?lstr29_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr29_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,373 :: 		return CheckSum;
	MOVF        Udp_CheckSum_CheckSum_L0+0, 0 
	MOVWF       R0 
	MOVF        Udp_CheckSum_CheckSum_L0+1, 0 
	MOVWF       R1 
;PIC_Client.c,374 :: 		}
L_end_Udp_CheckSum:
	RETURN      0
; end of _Udp_CheckSum

_Udp_Trans:

;PIC_Client.c,377 :: 		void Udp_Trans(PUdpStruct PUdpData, unsigned short PckLen) {
;PIC_Client.c,382 :: 		UART1_Write_Text("UDP Trans Pakke\n\r");
	MOVLW       ?lstr30_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr30_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,383 :: 		UdpLen = _SWAP(PUdpData->udp.Len);
	MOVLW       34
	ADDWF       FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       R1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVF        POSTINC0+0, 0 
	MOVWF       R6 
	MOVF        R6, 0 
	MOVWF       R3 
	CLRF        R4 
	MOVF        R5, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R3, 0 
	IORWF       R0, 1 
	MOVF        R4, 0 
	IORWF       R1, 1 
	MOVF        R0, 0 
	MOVWF       _UdpLen+0 
	MOVF        R1, 0 
	MOVWF       _UdpLen+1 
;PIC_Client.c,384 :: 		TekstLen = UdpLen - 8; //Tekst længde - UDP Hdr.
	MOVLW       8
	SUBWF       R0, 0 
	MOVWF       Udp_Trans_TekstLen_L0+0 
;PIC_Client.c,385 :: 		SwapAddr((PIpStruct) PUdpData);
	MOVF        FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       FARG_SwapAddr_IpData+0 
	MOVF        FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       FARG_SwapAddr_IpData+1 
	CALL        _SwapAddr+0, 0
;PIC_Client.c,386 :: 		temp = PUdpData->udp.SrcPort;
	MOVLW       34
	ADDWF       FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       R1 
	MOVFF       R0, FSR0
	MOVFF       R1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       Udp_Trans_temp_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       Udp_Trans_temp_L0+1 
;PIC_Client.c,387 :: 		PUdpData->udp.SrcPort = PUdpData->udp.DestPort;
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVFF       R0, FSR1
	MOVFF       R1, FSR1H
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,388 :: 		PUdpData->udp.DestPort = temp;
	MOVLW       34
	ADDWF       FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        Udp_Trans_temp_L0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        Udp_Trans_temp_L0+1, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,389 :: 		PUdpData->udp.CkSum = 0;
	MOVLW       34
	ADDWF       FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       R1 
	MOVLW       6
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;PIC_Client.c,391 :: 		for (i = 0; i <= TekstLen; i++) {
	CLRF        Udp_Trans_i_L0+0 
L_Udp_Trans52:
	MOVF        Udp_Trans_i_L0+0, 0 
	SUBWF       Udp_Trans_TekstLen_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Udp_Trans53
;PIC_Client.c,392 :: 		if (PUdpData->uddata[i] >= 'a' && PUdpData->uddata[i] <= 'z')
	MOVLW       42
	ADDWF       FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       R1 
	MOVF        Udp_Trans_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVLW       97
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Udp_Trans57
	MOVLW       42
	ADDWF       FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       R1 
	MOVF        Udp_Trans_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       122
	BTFSS       STATUS+0, 0 
	GOTO        L_Udp_Trans57
L__Udp_Trans283:
;PIC_Client.c,393 :: 		PUdpData->uddata[i].B5 = 0;
	MOVLW       42
	ADDWF       FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       R1 
	MOVF        Udp_Trans_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	BCF         POSTINC1+0, 5 
L_Udp_Trans57:
;PIC_Client.c,391 :: 		for (i = 0; i <= TekstLen; i++) {
	INCF        Udp_Trans_i_L0+0, 1 
;PIC_Client.c,394 :: 		}
	GOTO        L_Udp_Trans52
L_Udp_Trans53:
;PIC_Client.c,395 :: 		PUdpData->uddata[TekstLen] = 0;
	MOVLW       42
	ADDWF       FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       R1 
	MOVF        Udp_Trans_TekstLen_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,397 :: 		TxPacket((unsigned short * ) PUdpData, PckLen, FALSE); //Fill Eth Buffer Don't send
	MOVF        FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       FARG_TxPacket_PkData+0 
	MOVF        FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       FARG_TxPacket_PkData+1 
	MOVF        FARG_Udp_Trans_PckLen+0, 0 
	MOVWF       FARG_TxPacket_len+0 
	MOVLW       0
	MOVWF       FARG_TxPacket_len+1 
	CLRF        FARG_TxPacket_TX+0 
	CALL        _TxPacket+0, 0
;PIC_Client.c,399 :: 		PUdpData->udp.CkSum = Cksum(sizeof(IpStruct), UdpLen, 1); // Checksum with seed
	MOVLW       34
	ADDWF       FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       R1 
	MOVLW       6
	ADDWF       R0, 0 
	MOVWF       FLOC__Udp_Trans+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__Udp_Trans+1 
	MOVLW       34
	MOVWF       FARG_CkSum_offset+0 
	MOVLW       0
	MOVWF       FARG_CkSum_offset+1 
	MOVF        _UdpLen+0, 0 
	MOVWF       FARG_CkSum_Len+0 
	MOVF        _UdpLen+1, 0 
	MOVWF       FARG_CkSum_Len+1 
	MOVLW       1
	MOVWF       FARG_CkSum_Seed+0 
	CALL        _CkSum+0, 0
	MOVFF       FLOC__Udp_Trans+0, FSR1
	MOVFF       FLOC__Udp_Trans+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,400 :: 		ShowPacket((unsigned short * ) PUdpData, PckLen);
	MOVF        FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       FARG_ShowPacket_Buffer+0 
	MOVF        FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       FARG_ShowPacket_Buffer+1 
	MOVF        FARG_Udp_Trans_PckLen+0, 0 
	MOVWF       FARG_ShowPacket_len+0 
	MOVLW       0
	MOVWF       FARG_ShowPacket_len+1 
	CALL        _ShowPacket+0, 0
;PIC_Client.c,401 :: 		TxPacket((unsigned short * ) PUdpData, PckLen, TRUE); //Fill Eth Buffer And send
	MOVF        FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       FARG_TxPacket_PkData+0 
	MOVF        FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       FARG_TxPacket_PkData+1 
	MOVF        FARG_Udp_Trans_PckLen+0, 0 
	MOVWF       FARG_TxPacket_len+0 
	MOVLW       0
	MOVWF       FARG_TxPacket_len+1 
	MOVLW       1
	MOVWF       FARG_TxPacket_TX+0 
	CALL        _TxPacket+0, 0
;PIC_Client.c,402 :: 		}
L_end_Udp_Trans:
	RETURN      0
; end of _Udp_Trans

_Icmp:

;PIC_Client.c,404 :: 		void Icmp(PIcmpStruct PIcmpData, unsigned short PckLen) {
;PIC_Client.c,406 :: 		PIcmpData->icmp.Type = 0x00;
	MOVLW       34
	ADDWF       FARG_Icmp_PIcmpData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Icmp_PIcmpData+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,407 :: 		PIcmpData->icmp.Code = 0x00; //Set Echo Reply
	MOVLW       34
	ADDWF       FARG_Icmp_PIcmpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Icmp_PIcmpData+1, 0 
	MOVWF       R1 
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,408 :: 		PIcmpData->icmp.CkSum = 0x0000; //Clear ICMP checksum
	MOVLW       34
	ADDWF       FARG_Icmp_PIcmpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Icmp_PIcmpData+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;PIC_Client.c,409 :: 		PIcmpData->ip.CkSum = 0x0000; //Clear IP checksum
	MOVLW       14
	ADDWF       FARG_Icmp_PIcmpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Icmp_PIcmpData+1, 0 
	MOVWF       R1 
	MOVLW       10
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;PIC_Client.c,410 :: 		SwapAddr((PIpStruct) PIcmpData);
	MOVF        FARG_Icmp_PIcmpData+0, 0 
	MOVWF       FARG_SwapAddr_IpData+0 
	MOVF        FARG_Icmp_PIcmpData+1, 0 
	MOVWF       FARG_SwapAddr_IpData+1 
	CALL        _SwapAddr+0, 0
;PIC_Client.c,411 :: 		TxPacket((unsigned short * ) PIcmpData, PckLen, 0); //Fill Eth Buffer Don't send
	MOVF        FARG_Icmp_PIcmpData+0, 0 
	MOVWF       FARG_TxPacket_PkData+0 
	MOVF        FARG_Icmp_PIcmpData+1, 0 
	MOVWF       FARG_TxPacket_PkData+1 
	MOVF        FARG_Icmp_PckLen+0, 0 
	MOVWF       FARG_TxPacket_len+0 
	MOVLW       0
	MOVWF       FARG_TxPacket_len+1 
	CLRF        FARG_TxPacket_TX+0 
	CALL        _TxPacket+0, 0
;PIC_Client.c,413 :: 		PIcmpData->ip.CkSum = CkSum(sizeof(EthHdr), sizeof(IpHdr), 0);
	MOVLW       14
	ADDWF       FARG_Icmp_PIcmpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Icmp_PIcmpData+1, 0 
	MOVWF       R1 
	MOVLW       10
	ADDWF       R0, 0 
	MOVWF       FLOC__Icmp+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__Icmp+1 
	MOVLW       14
	MOVWF       FARG_CkSum_offset+0 
	MOVLW       0
	MOVWF       FARG_CkSum_offset+1 
	MOVLW       20
	MOVWF       FARG_CkSum_Len+0 
	MOVLW       0
	MOVWF       FARG_CkSum_Len+1 
	CLRF        FARG_CkSum_Seed+0 
	CALL        _CkSum+0, 0
	MOVFF       FLOC__Icmp+0, FSR1
	MOVFF       FLOC__Icmp+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,415 :: 		len = SWAP(PIcmpData->ip.PktLen);
	MOVLW       14
	ADDWF       FARG_Icmp_PIcmpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Icmp_PIcmpData+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Swap_input+0 
	CALL        _Swap+0, 0
;PIC_Client.c,416 :: 		PIcmpData->icmp.CkSum = CkSum(sizeof(IpStruct), PckLen - sizeof(IpStruct), 0); //ICMP hdr + Data Payload
	MOVLW       34
	ADDWF       FARG_Icmp_PIcmpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Icmp_PIcmpData+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FLOC__Icmp+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__Icmp+1 
	MOVLW       34
	MOVWF       FARG_CkSum_offset+0 
	MOVLW       0
	MOVWF       FARG_CkSum_offset+1 
	MOVLW       34
	SUBWF       FARG_Icmp_PckLen+0, 0 
	MOVWF       FARG_CkSum_Len+0 
	CLRF        FARG_CkSum_Len+1 
	MOVLW       0
	SUBWFB      FARG_CkSum_Len+1, 1 
	CLRF        FARG_CkSum_Seed+0 
	CALL        _CkSum+0, 0
	MOVFF       FLOC__Icmp+0, FSR1
	MOVFF       FLOC__Icmp+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,417 :: 		TxPacket((unsigned short * ) PIcmpData, PckLen, 1); //Fill Eth Buffer And send
	MOVF        FARG_Icmp_PIcmpData+0, 0 
	MOVWF       FARG_TxPacket_PkData+0 
	MOVF        FARG_Icmp_PIcmpData+1, 0 
	MOVWF       FARG_TxPacket_PkData+1 
	MOVF        FARG_Icmp_PckLen+0, 0 
	MOVWF       FARG_TxPacket_len+0 
	MOVLW       0
	MOVWF       FARG_TxPacket_len+1 
	MOVLW       1
	MOVWF       FARG_TxPacket_TX+0 
	CALL        _TxPacket+0, 0
;PIC_Client.c,418 :: 		}
L_end_Icmp:
	RETURN      0
; end of _Icmp

_Arp:

;PIC_Client.c,420 :: 		void Arp(PArpStruct PArpData, unsigned short PckLen) {
;PIC_Client.c,424 :: 		PArpData->arp.OpCode = _SWAP(0x0002);
	MOVLW       14
	ADDWF       FARG_Arp_PArpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Arp_PArpData+1, 0 
	MOVWF       R1 
	MOVLW       6
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       0
	MOVWF       POSTINC1+0 
	MOVLW       2
	MOVWF       POSTINC1+0 
;PIC_Client.c,425 :: 		for (i = 0; i <= 5; i++) {
	CLRF        Arp_i_L0+0 
L_Arp58:
	MOVF        Arp_i_L0+0, 0 
	SUBLW       5
	BTFSS       STATUS+0, 0 
	GOTO        L_Arp59
;PIC_Client.c,426 :: 		PArpData->eth.DestMac[i] = PArpData->eth.ScrMac[i];
	MOVF        Arp_i_L0+0, 0 
	ADDWF       FARG_Arp_PArpData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Arp_PArpData+1, 0 
	MOVWF       FSR1H 
	MOVLW       6
	ADDWF       FARG_Arp_PArpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Arp_PArpData+1, 0 
	MOVWF       R1 
	MOVF        Arp_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,427 :: 		PArpData->arp.THwAddr[i] = PArpData->arp.SHwAddr[i];
	MOVLW       14
	ADDWF       FARG_Arp_PArpData+0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      FARG_Arp_PArpData+1, 0 
	MOVWF       R3 
	MOVLW       18
	ADDWF       R2, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R3, 0 
	MOVWF       R1 
	MOVF        Arp_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       8
	ADDWF       R2, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R3, 0 
	MOVWF       R1 
	MOVF        Arp_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,428 :: 		PArpData->eth.ScrMac[i] = MyMacAddr[i];
	MOVLW       6
	ADDWF       FARG_Arp_PArpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Arp_PArpData+1, 0 
	MOVWF       R1 
	MOVF        Arp_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       _myMacAddr+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_myMacAddr+0)
	MOVWF       FSR0H 
	MOVF        Arp_i_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,429 :: 		PArpData->arp.SHwAddr[i] = MyMacAddr[i];
	MOVLW       14
	ADDWF       FARG_Arp_PArpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Arp_PArpData+1, 0 
	MOVWF       R1 
	MOVLW       8
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        Arp_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       _myMacAddr+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_myMacAddr+0)
	MOVWF       FSR0H 
	MOVF        Arp_i_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,425 :: 		for (i = 0; i <= 5; i++) {
	INCF        Arp_i_L0+0, 1 
;PIC_Client.c,430 :: 		}
	GOTO        L_Arp58
L_Arp59:
;PIC_Client.c,431 :: 		for (i = 0; i <= 3; i++) {
	CLRF        Arp_i_L0+0 
L_Arp61:
	MOVF        Arp_i_L0+0, 0 
	SUBLW       3
	BTFSS       STATUS+0, 0 
	GOTO        L_Arp62
;PIC_Client.c,432 :: 		PArpData->arp.TIpAddr[i] = PArpData->arp.SIpAddr[i];
	MOVLW       14
	ADDWF       FARG_Arp_PArpData+0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      FARG_Arp_PArpData+1, 0 
	MOVWF       R3 
	MOVLW       24
	ADDWF       R2, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R3, 0 
	MOVWF       R1 
	MOVF        Arp_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       14
	ADDWF       R2, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R3, 0 
	MOVWF       R1 
	MOVF        Arp_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,433 :: 		PArpData->arp.SIpAddr[i] = MyIpAddr[i];
	MOVLW       14
	ADDWF       FARG_Arp_PArpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_Arp_PArpData+1, 0 
	MOVWF       R1 
	MOVLW       14
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        Arp_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       _myIpAddr+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_myIpAddr+0)
	MOVWF       FSR0H 
	MOVF        Arp_i_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,431 :: 		for (i = 0; i <= 3; i++) {
	INCF        Arp_i_L0+0, 1 
;PIC_Client.c,434 :: 		}
	GOTO        L_Arp61
L_Arp62:
;PIC_Client.c,436 :: 		TxPacket((unsigned short * ) PArpData, Len, 1);
	MOVF        FARG_Arp_PArpData+0, 0 
	MOVWF       FARG_TxPacket_PkData+0 
	MOVF        FARG_Arp_PArpData+1, 0 
	MOVWF       FARG_TxPacket_PkData+1 
	MOVLW       42
	MOVWF       FARG_TxPacket_len+0 
	MOVLW       0
	MOVWF       FARG_TxPacket_len+1 
	MOVLW       1
	MOVWF       FARG_TxPacket_TX+0 
	CALL        _TxPacket+0, 0
;PIC_Client.c,437 :: 		}
L_end_Arp:
	RETURN      0
; end of _Arp

_UdPacket:

;PIC_Client.c,439 :: 		void UdPacket(unsigned short * Data, unsigned len) {
;PIC_Client.c,440 :: 		WriteReg(EUDAWRPT, UDASTART);
	MOVLW       144
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       82
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       6
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,441 :: 		WriteReg(EUDARDPT, UDASTART);
	MOVLW       142
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       82
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       6
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,442 :: 		WriteMemoryWindow(UDA_WINDOW, Data, len);
	MOVLW       1
	MOVWF       FARG_WriteMemoryWindow_vWindow+0 
	MOVF        FARG_UdPacket_Data+0, 0 
	MOVWF       FARG_WriteMemoryWindow_vData+0 
	MOVF        FARG_UdPacket_Data+1, 0 
	MOVWF       FARG_WriteMemoryWindow_vData+1 
	MOVF        FARG_UdPacket_len+0, 0 
	MOVWF       FARG_WriteMemoryWindow_wLength+0 
	MOVF        FARG_UdPacket_len+1, 0 
	MOVWF       FARG_WriteMemoryWindow_wLength+1 
	CALL        _WriteMemoryWindow+0, 0
;PIC_Client.c,444 :: 		}
L_end_UdPacket:
	RETURN      0
; end of _UdPacket

_TxPacket:

;PIC_Client.c,446 :: 		void TxPacket(unsigned short * PkData, unsigned len, unsigned short TX) {
;PIC_Client.c,448 :: 		do {
L_TxPacket64:
;PIC_Client.c,449 :: 		read = ReadReg(ECON1);
	MOVLW       30
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
;PIC_Client.c,450 :: 		} while (Read & ECON1_TXRTS);
	BTFSC       R0, 1 
	GOTO        L_TxPacket64
;PIC_Client.c,451 :: 		WriteReg(ERXWRPT, TXSTART);
	MOVLW       140
	MOVWF       FARG_WriteReg_wAddress+0 
	CLRF        FARG_WriteReg_wValue+0 
	CLRF        FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,452 :: 		WriteMemoryWindow(RX_WINDOW, PkData, len);
	MOVLW       4
	MOVWF       FARG_WriteMemoryWindow_vWindow+0 
	MOVF        FARG_TxPacket_PkData+0, 0 
	MOVWF       FARG_WriteMemoryWindow_vData+0 
	MOVF        FARG_TxPacket_PkData+1, 0 
	MOVWF       FARG_WriteMemoryWindow_vData+1 
	MOVF        FARG_TxPacket_len+0, 0 
	MOVWF       FARG_WriteMemoryWindow_wLength+0 
	MOVF        FARG_TxPacket_len+1, 0 
	MOVWF       FARG_WriteMemoryWindow_wLength+1 
	CALL        _WriteMemoryWindow+0, 0
;PIC_Client.c,453 :: 		if (TX) {
	MOVF        FARG_TxPacket_TX+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_TxPacket67
;PIC_Client.c,454 :: 		WriteReg(ETXST, (unsigned) 0x0000);
	CLRF        FARG_WriteReg_wAddress+0 
	CLRF        FARG_WriteReg_wValue+0 
	CLRF        FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,455 :: 		WriteReg(ETXLEN, len);
	MOVLW       2
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVF        FARG_TxPacket_len+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVF        FARG_TxPacket_len+1, 0 
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,456 :: 		do {
L_TxPacket68:
;PIC_Client.c,457 :: 		read = ReadReg(ECON1);
	MOVLW       30
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
;PIC_Client.c,458 :: 		} while (Read & ECON1_TXRTS);
	BTFSC       R0, 1 
	GOTO        L_TxPacket68
;PIC_Client.c,460 :: 		ChkLink();
	CALL        _ChkLink+0, 0
;PIC_Client.c,461 :: 		}
L_TxPacket67:
;PIC_Client.c,462 :: 		}
L_end_TxPacket:
	RETURN      0
; end of _TxPacket

_swapByteOrder:

;PIC_Client.c,464 :: 		unsigned long swapByteOrder(unsigned long ui) {
;PIC_Client.c,465 :: 		ui = (ui >> 24) |
	MOVF        FARG_swapByteOrder_ui+3, 0 
	MOVWF       R5 
	CLRF        R6 
	CLRF        R7 
	CLRF        R8 
;PIC_Client.c,466 :: 		((ui << 8) & 0x00FF0000) |
	MOVF        FARG_swapByteOrder_ui+2, 0 
	MOVWF       R3 
	MOVF        FARG_swapByteOrder_ui+1, 0 
	MOVWF       R2 
	MOVF        FARG_swapByteOrder_ui+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVLW       0
	ANDWF       R0, 1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVLW       255
	ANDWF       R2, 1 
	MOVLW       0
	ANDWF       R3, 1 
	MOVF        R0, 0 
	IORWF       R5, 1 
	MOVF        R1, 0 
	IORWF       R6, 1 
	MOVF        R2, 0 
	IORWF       R7, 1 
	MOVF        R3, 0 
	IORWF       R8, 1 
;PIC_Client.c,467 :: 		((ui >> 8) & 0x0000FF00) |
	MOVF        FARG_swapByteOrder_ui+1, 0 
	MOVWF       R0 
	MOVF        FARG_swapByteOrder_ui+2, 0 
	MOVWF       R1 
	MOVF        FARG_swapByteOrder_ui+3, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	ANDWF       R0, 1 
	MOVLW       255
	ANDWF       R1, 1 
	MOVLW       0
	ANDWF       R2, 1 
	ANDWF       R3, 1 
	MOVF        R0, 0 
	IORWF       R5, 1 
	MOVF        R1, 0 
	IORWF       R6, 1 
	MOVF        R2, 0 
	IORWF       R7, 1 
	MOVF        R3, 0 
	IORWF       R8, 1 
;PIC_Client.c,468 :: 		(ui << 24);
	MOVF        FARG_swapByteOrder_ui+0, 0 
	MOVWF       R3 
	CLRF        R0 
	CLRF        R1 
	CLRF        R2 
	MOVF        R5, 0 
	IORWF       R0, 1 
	MOVF        R6, 0 
	IORWF       R1, 1 
	MOVF        R7, 0 
	IORWF       R2, 1 
	MOVF        R8, 0 
	IORWF       R3, 1 
	MOVF        R0, 0 
	MOVWF       FARG_swapByteOrder_ui+0 
	MOVF        R1, 0 
	MOVWF       FARG_swapByteOrder_ui+1 
	MOVF        R2, 0 
	MOVWF       FARG_swapByteOrder_ui+2 
	MOVF        R3, 0 
	MOVWF       FARG_swapByteOrder_ui+3 
;PIC_Client.c,469 :: 		return ui;
;PIC_Client.c,470 :: 		}
L_end_swapByteOrder:
	RETURN      0
; end of _swapByteOrder

_SwapAddr:

;PIC_Client.c,472 :: 		void SwapAddr(PIpStruct ipData) {
;PIC_Client.c,475 :: 		for (i = 0; i <= 5; i++) {
	CLRF        R4 
L_SwapAddr71:
	MOVF        R4, 0 
	SUBLW       5
	BTFSS       STATUS+0, 0 
	GOTO        L_SwapAddr72
;PIC_Client.c,476 :: 		ipData->eth.DestMac[i] = ipData->eth.ScrMac[i];
	MOVF        R4, 0 
	ADDWF       FARG_SwapAddr_ipData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_SwapAddr_ipData+1, 0 
	MOVWF       FSR1H 
	MOVLW       6
	ADDWF       FARG_SwapAddr_ipData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SwapAddr_ipData+1, 0 
	MOVWF       R1 
	MOVF        R4, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,477 :: 		ipData->eth.ScrMac[i] = MyMacAddr[i];
	MOVLW       6
	ADDWF       FARG_SwapAddr_ipData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SwapAddr_ipData+1, 0 
	MOVWF       R1 
	MOVF        R4, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       _myMacAddr+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_myMacAddr+0)
	MOVWF       FSR0H 
	MOVF        R4, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,475 :: 		for (i = 0; i <= 5; i++) {
	INCF        R4, 1 
;PIC_Client.c,478 :: 		}
	GOTO        L_SwapAddr71
L_SwapAddr72:
;PIC_Client.c,479 :: 		for (i = 0; i <= 3; i++) {
	CLRF        R4 
L_SwapAddr74:
	MOVF        R4, 0 
	SUBLW       3
	BTFSS       STATUS+0, 0 
	GOTO        L_SwapAddr75
;PIC_Client.c,480 :: 		ipData->ip.DestAddr[i] = ipData->ip.ScrAddr[i];
	MOVLW       14
	ADDWF       FARG_SwapAddr_ipData+0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      FARG_SwapAddr_ipData+1, 0 
	MOVWF       R3 
	MOVLW       16
	ADDWF       R2, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R3, 0 
	MOVWF       R1 
	MOVF        R4, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       12
	ADDWF       R2, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R3, 0 
	MOVWF       R1 
	MOVF        R4, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,481 :: 		ipData->ip.Scraddr[i] = MyIpAddr[i];
	MOVLW       14
	ADDWF       FARG_SwapAddr_ipData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SwapAddr_ipData+1, 0 
	MOVWF       R1 
	MOVLW       12
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        R4, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       _myIpAddr+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_myIpAddr+0)
	MOVWF       FSR0H 
	MOVF        R4, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,479 :: 		for (i = 0; i <= 3; i++) {
	INCF        R4, 1 
;PIC_Client.c,482 :: 		}
	GOTO        L_SwapAddr74
L_SwapAddr75:
;PIC_Client.c,483 :: 		}
L_end_SwapAddr:
	RETURN      0
; end of _SwapAddr

_CkSum:

;PIC_Client.c,486 :: 		unsigned int CkSum(unsigned offset, unsigned Len, unsigned short Seed) {
;PIC_Client.c,489 :: 		do {
L_CkSum77:
;PIC_Client.c,490 :: 		Read = ReadReg(ECON1);
	MOVLW       30
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
;PIC_Client.c,491 :: 		} while (Read & ECON1_DMAST);
	BTFSC       R0, 5 
	GOTO        L_CkSum77
;PIC_Client.c,493 :: 		BFCREG(ECON1, ECON1_DMACPY);
	MOVLW       30
	MOVWF       FARG_BFCReg_wAddress+0 
	MOVLW       16
	MOVWF       FARG_BFCReg_wBitMask+0 
	CALL        _BFCReg+0, 0
;PIC_Client.c,494 :: 		BFCREG(ECON1, ECON1_DMANOCS);
	MOVLW       30
	MOVWF       FARG_BFCReg_wAddress+0 
	MOVLW       4
	MOVWF       FARG_BFCReg_wBitMask+0 
	CALL        _BFCReg+0, 0
;PIC_Client.c,495 :: 		if (Seed)
	MOVF        FARG_CkSum_Seed+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_CkSum80
;PIC_Client.c,496 :: 		BFSREG(ECON1, ECON1_DMACSSD);
	MOVLW       30
	MOVWF       FARG_BFSReg_wAddress+0 
	MOVLW       8
	MOVWF       FARG_BFSReg_wBitMask+0 
	CALL        _BFSReg+0, 0
	GOTO        L_CkSum81
L_CkSum80:
;PIC_Client.c,498 :: 		BFCREG(ECON1, ECON1_DMACSSD);
	MOVLW       30
	MOVWF       FARG_BFCReg_wAddress+0 
	MOVLW       8
	MOVWF       FARG_BFCReg_wBitMask+0 
	CALL        _BFCReg+0, 0
L_CkSum81:
;PIC_Client.c,500 :: 		WriteReg(EDMAST, TXSTART + offset);
	MOVLW       10
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVF        FARG_CkSum_offset+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVF        FARG_CkSum_offset+1, 0 
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,501 :: 		WriteReg(EDMALEN, Len);
	MOVLW       12
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVF        FARG_CkSum_Len+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVF        FARG_CkSum_Len+1, 0 
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,503 :: 		BFSREG(ECON1, ECON1_DMAST);
	MOVLW       30
	MOVWF       FARG_BFSReg_wAddress+0 
	MOVLW       32
	MOVWF       FARG_BFSReg_wBitMask+0 
	CALL        _BFSReg+0, 0
;PIC_Client.c,504 :: 		do {
L_CkSum82:
;PIC_Client.c,505 :: 		read = ReadReg(ECON1);
	MOVLW       30
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
;PIC_Client.c,506 :: 		} while (Read & ECON1_DMAST);
	BTFSC       R0, 5 
	GOTO        L_CkSum82
;PIC_Client.c,508 :: 		read = (ReadReg(EDMACS));
	MOVLW       16
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
;PIC_Client.c,509 :: 		return read;
;PIC_Client.c,510 :: 		}
L_end_CkSum:
	RETURN      0
; end of _CkSum

_MACInit:

;PIC_Client.c,529 :: 		void MACInit(void) {
;PIC_Client.c,532 :: 		DeassertChipSelect();
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,534 :: 		ConfigureSPIModule();
	BCF         TRISC1_bit+0, BitPos(TRISC1_bit+0) 
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
	BCF         TRISC3_bit+0, BitPos(TRISC3_bit+0) 
	BSF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
	CLRF        SSP1CON1+0 
	MOVLW       64
	MOVWF       SSP1STAT+0 
	MOVLW       32
	MOVWF       SSP1CON1+0 
;PIC_Client.c,535 :: 		ClearSPIDoneFlag();
	BCF         PIR1+0, 3 
;PIC_Client.c,539 :: 		SendSystemReset();
	CALL        _SendSystemReset+0, 0
;PIC_Client.c,541 :: 		RegValue = ReadReg(MAADR1);
	MOVLW       100
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       _RegValue+0 
	MOVF        R1, 0 
	MOVWF       _RegValue+1 
;PIC_Client.c,542 :: 		myMacAddr[0] = LOW(RegValue);
	MOVLW       255
	ANDWF       R0, 0 
	MOVWF       _myMacAddr+0 
;PIC_Client.c,543 :: 		myMacAddr[1] = HIGH(RegValue);
	MOVF        R1, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       255
	ANDWF       R2, 0 
	MOVWF       _myMacAddr+1 
;PIC_Client.c,544 :: 		RegValue = ReadReg(MAADR2);
	MOVLW       98
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       _RegValue+0 
	MOVF        R1, 0 
	MOVWF       _RegValue+1 
;PIC_Client.c,545 :: 		myMacAddr[2] = LOW(RegValue);
	MOVLW       255
	ANDWF       R0, 0 
	MOVWF       _myMacAddr+2 
;PIC_Client.c,546 :: 		myMacAddr[3] = HIGH(RegValue);
	MOVF        R1, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       255
	ANDWF       R2, 0 
	MOVWF       _myMacAddr+3 
;PIC_Client.c,547 :: 		RegValue = ReadReg(MAADR3);
	MOVLW       96
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       _RegValue+0 
	MOVF        R1, 0 
	MOVWF       _RegValue+1 
;PIC_Client.c,548 :: 		myMacAddr[4] = LOW(RegValue);
	MOVLW       255
	ANDWF       R0, 0 
	MOVWF       _myMacAddr+4 
;PIC_Client.c,549 :: 		myMacAddr[5] = HIGH(RegValue);
	MOVF        R1, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       255
	ANDWF       R2, 0 
	MOVWF       _myMacAddr+5 
;PIC_Client.c,553 :: 		NextPacketPointer = RXSTART;
	MOVLW       64
	MOVWF       _NextPacketPointer+0 
	MOVLW       83
	MOVWF       _NextPacketPointer+1 
;PIC_Client.c,554 :: 		WriteReg(ETXST, TXSTART);
	CLRF        FARG_WriteReg_wAddress+0 
	CLRF        FARG_WriteReg_wValue+0 
	CLRF        FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,555 :: 		WriteReg(ERXST, RXSTART);
	MOVLW       4
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       64
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       83
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,556 :: 		WriteReg(ERXRDPT, RXSTART);
	MOVLW       138
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       64
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       83
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,557 :: 		WriteReg(ERXTAIL, RXEND - 2);
	MOVLW       6
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       253
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       95
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,562 :: 		WritePHYReg(PHANA, PHANA_ADPAUS0 | PHANA_AD10FD | PHANA_AD10 | PHANA_AD100FD | PHANA_AD100 | PHANA_ADIEEE0);
	MOVLW       4
	MOVWF       FARG_WritePHYReg_Register+0 
	MOVLW       225
	MOVWF       FARG_WritePHYReg_Data+0 
	CALL        _WritePHYReg+0, 0
;PIC_Client.c,565 :: 		EXECUTE0(ENABLERX);
	MOVLW       232
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
;PIC_Client.c,566 :: 		} //end MACInit
L_end_MACInit:
	RETURN      0
; end of _MACInit

_ChkPck:

;PIC_Client.c,568 :: 		unsigned ChkPck() {
;PIC_Client.c,571 :: 		RegValue = ReadReg(EIR);
	MOVLW       28
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       _RegValue+0 
	MOVF        R1, 0 
	MOVWF       _RegValue+1 
;PIC_Client.c,572 :: 		if (!(RegValue & EIR_PKTIF))
	BTFSC       R0, 6 
	GOTO        L_ChkPck94
;PIC_Client.c,574 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_ChkPck
;PIC_Client.c,575 :: 		}
L_ChkPck94:
;PIC_Client.c,577 :: 		RegValue = ReadReg(ESTAT);
	MOVLW       26
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       _RegValue+0 
	MOVF        R1, 0 
	MOVWF       _RegValue+1 
;PIC_Client.c,578 :: 		PckCnt = LOW(RegValue);
	MOVLW       255
	ANDWF       R0, 0 
	MOVWF       R0 
;PIC_Client.c,579 :: 		if (PckCnt) {
	BTFSC       STATUS+0, 2 
	GOTO        L_ChkPck95
;PIC_Client.c,580 :: 		PckLen = GetFrame();
	CALL        _GetFrame+0, 0
	MOVF        R0, 0 
	MOVWF       _PckLen+0 
	MOVF        R1, 0 
	MOVWF       _PckLen+1 
;PIC_Client.c,581 :: 		return PckLen;
	GOTO        L_end_ChkPck
;PIC_Client.c,582 :: 		}
L_ChkPck95:
;PIC_Client.c,583 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
;PIC_Client.c,584 :: 		}
L_end_ChkPck:
	RETURN      0
; end of _ChkPck

_GetFrame:

;PIC_Client.c,586 :: 		unsigned GetFrame() {
;PIC_Client.c,590 :: 		WriteReg(ERXRDPT, NextPacketPointer);
	MOVLW       138
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVF        _NextPacketPointer+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVF        _NextPacketPointer+1, 0 
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,592 :: 		ReadMemoryWindow(RX_WINDOW, PckHdr, 8);
	MOVLW       4
	MOVWF       FARG_ReadMemoryWindow_vWindow+0 
	MOVLW       GetFrame_PckHdr_L0+0
	MOVWF       FARG_ReadMemoryWindow_vData+0 
	MOVLW       hi_addr(GetFrame_PckHdr_L0+0)
	MOVWF       FARG_ReadMemoryWindow_vData+1 
	MOVLW       8
	MOVWF       FARG_ReadMemoryWindow_wLength+0 
	MOVLW       0
	MOVWF       FARG_ReadMemoryWindow_wLength+1 
	CALL        _ReadMemoryWindow+0, 0
;PIC_Client.c,593 :: 		RXData = (PRXStruct) PckHdr;
	MOVLW       GetFrame_PckHdr_L0+0
	MOVWF       _RXData+0 
	MOVLW       hi_addr(GetFrame_PckHdr_L0+0)
	MOVWF       _RXData+1 
;PIC_Client.c,595 :: 		NextPacketPointer = RXData->NextPtr;
	MOVFF       _RXData+0, FSR0
	MOVFF       _RXData+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       _NextPacketPointer+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       _NextPacketPointer+1 
;PIC_Client.c,596 :: 		RxLen = RXData->ByteCount;
	MOVLW       2
	ADDWF       _RXData+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      _RXData+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       GetFrame_RxLen_L0+0 
	MOVF        R2, 0 
	MOVWF       GetFrame_RxLen_L0+1 
;PIC_Client.c,597 :: 		if (RxLen > 200) Rxlen = 200;
	MOVLW       0
	MOVWF       R0 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GetFrame316
	MOVF        R1, 0 
	SUBLW       200
L__GetFrame316:
	BTFSC       STATUS+0, 0 
	GOTO        L_GetFrame96
	MOVLW       200
	MOVWF       GetFrame_RxLen_L0+0 
	MOVLW       0
	MOVWF       GetFrame_RxLen_L0+1 
L_GetFrame96:
;PIC_Client.c,599 :: 		ReadMemoryWindow(RX_WINDOW, packet, RxLen);
	MOVLW       4
	MOVWF       FARG_ReadMemoryWindow_vWindow+0 
	MOVLW       _Packet+0
	MOVWF       FARG_ReadMemoryWindow_vData+0 
	MOVLW       hi_addr(_Packet+0)
	MOVWF       FARG_ReadMemoryWindow_vData+1 
	MOVF        GetFrame_RxLen_L0+0, 0 
	MOVWF       FARG_ReadMemoryWindow_wLength+0 
	MOVF        GetFrame_RxLen_L0+1, 0 
	MOVWF       FARG_ReadMemoryWindow_wLength+1 
	CALL        _ReadMemoryWindow+0, 0
;PIC_Client.c,601 :: 		WriteReg(ERXTAIL, RXData->NextPtr - 2);
	MOVLW       6
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVFF       _RXData+0, FSR0
	MOVFF       _RXData+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       2
	SUBWF       R0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       0
	SUBWFB      R1, 0 
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,603 :: 		RxLen -= 4; //!!!!!!!!
	MOVLW       4
	SUBWF       GetFrame_RxLen_L0+0, 1 
	MOVLW       0
	SUBWFB      GetFrame_RxLen_L0+1, 1 
;PIC_Client.c,604 :: 		Execute0(SETPKTDEC);
	MOVLW       204
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
;PIC_Client.c,606 :: 		if (RXData->ReceiveOk) return (RxLen);
	MOVLW       4
	ADDWF       _RXData+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      _RXData+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSS       R0, 7 
	GOTO        L_GetFrame97
	MOVF        GetFrame_RxLen_L0+0, 0 
	MOVWF       R0 
	MOVF        GetFrame_RxLen_L0+1, 0 
	MOVWF       R1 
	GOTO        L_end_GetFrame
L_GetFrame97:
;PIC_Client.c,607 :: 		else return 0;
	CLRF        R0 
	CLRF        R1 
;PIC_Client.c,608 :: 		}
L_end_GetFrame:
	RETURN      0
; end of _GetFrame

_ChkLink:

;PIC_Client.c,632 :: 		void ChkLink(void) {
;PIC_Client.c,640 :: 		if (ReadReg(EIR) & EIR_LINKIF) {
	MOVLW       28
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	BTFSS       R1, 3 
	GOTO        L_ChkLink99
;PIC_Client.c,641 :: 		BFCReg(EIR, EIR_LINKIF);
	MOVLW       28
	MOVWF       FARG_BFCReg_wAddress+0 
	MOVLW       0
	MOVWF       FARG_BFCReg_wBitMask+0 
	CALL        _BFCReg+0, 0
;PIC_Client.c,644 :: 		w = ReadReg(MACON2);
	MOVLW       66
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       ChkLink_w_L0+0 
	MOVF        R1, 0 
	MOVWF       ChkLink_w_L0+1 
;PIC_Client.c,645 :: 		if (ReadReg(ESTAT) & ESTAT_PHYDPX) {
	MOVLW       26
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	BTFSS       R1, 2 
	GOTO        L_ChkLink100
;PIC_Client.c,647 :: 		WriteReg(MABBIPG, 0x15);
	MOVLW       68
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       21
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       0
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,648 :: 		w |= MACON2_FULDPX;
	BSF         ChkLink_w_L0+0, 0 
;PIC_Client.c,649 :: 		} else {
	GOTO        L_ChkLink101
L_ChkLink100:
;PIC_Client.c,651 :: 		WriteReg(MABBIPG, 0x12);
	MOVLW       68
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       18
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       0
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,652 :: 		w &= ~MACON2_FULDPX;
	BCF         ChkLink_w_L0+0, 0 
;PIC_Client.c,653 :: 		}
L_ChkLink101:
;PIC_Client.c,654 :: 		WriteReg(MACON2, w);
	MOVLW       66
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVF        ChkLink_w_L0+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVF        ChkLink_w_L0+1, 0 
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,655 :: 		}
L_ChkLink99:
;PIC_Client.c,666 :: 		do {
L_ChkLink102:
;PIC_Client.c,667 :: 		RegValue = ReadReg(ESTAT);
	MOVLW       26
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       _RegValue+0 
	MOVF        R1, 0 
	MOVWF       _RegValue+1 
;PIC_Client.c,668 :: 		} while (!(RegValue & ESTAT_PHYLNK));
	BTFSS       R1, 0 
	GOTO        L_ChkLink102
;PIC_Client.c,670 :: 		EXECUTE0(SETTXRTS);
	MOVLW       212
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
;PIC_Client.c,672 :: 		do {
L_ChkLink105:
;PIC_Client.c,673 :: 		RegValue = ReadReg(ECON1);
	MOVLW       30
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       _RegValue+0 
	MOVF        R1, 0 
	MOVWF       _RegValue+1 
;PIC_Client.c,674 :: 		} while (RegValue & ECON1_TXRTS);
	BTFSC       R0, 1 
	GOTO        L_ChkLink105
;PIC_Client.c,675 :: 		}
L_end_ChkLink:
	RETURN      0
; end of _ChkLink

_SendSystemReset:

;PIC_Client.c,711 :: 		void SendSystemReset(void) {
;PIC_Client.c,713 :: 		do {
L_SendSystemReset108:
;PIC_Client.c,720 :: 		do {
L_SendSystemReset111:
;PIC_Client.c,721 :: 		WriteReg(EUDAST, 0x1234);
	MOVLW       22
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       52
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       18
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,722 :: 		} while (ReadReg(EUDAST) != 0x1234u);
	MOVLW       22
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R1, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L__SendSystemReset319
	MOVLW       52
	XORWF       R0, 0 
L__SendSystemReset319:
	BTFSS       STATUS+0, 2 
	GOTO        L_SendSystemReset111
;PIC_Client.c,725 :: 		Execute0(SETETHRST);
	MOVLW       202
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
;PIC_Client.c,726 :: 		vCurrentBank = 0;
	CLRF        _vCurrentBank+0 
;PIC_Client.c,727 :: 		while ((ReadReg(ESTAT) & (ESTAT_CLKRDY | ESTAT_RSTDONE | ESTAT_PHYRDY)) != (ESTAT_CLKRDY | ESTAT_RSTDONE | ESTAT_PHYRDY));
L_SendSystemReset114:
	MOVLW       26
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVLW       0
	ANDWF       R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	ANDLW       26
	MOVWF       R3 
	MOVF        R3, 0 
	XORLW       26
	BTFSS       STATUS+0, 2 
	GOTO        L__SendSystemReset320
	MOVLW       0
	XORWF       R2, 0 
L__SendSystemReset320:
	BTFSC       STATUS+0, 2 
	GOTO        L_SendSystemReset115
	GOTO        L_SendSystemReset114
L_SendSystemReset115:
;PIC_Client.c,728 :: 		Delay_us(30);
	MOVLW       79
	MOVWF       R13, 0
L_SendSystemReset116:
	DECFSZ      R13, 1, 1
	BRA         L_SendSystemReset116
	NOP
	NOP
;PIC_Client.c,735 :: 		} while (ReadReg(EUDAST) != 0x0000u);
	MOVLW       22
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SendSystemReset321
	MOVLW       0
	XORWF       R0, 0 
L__SendSystemReset321:
	BTFSS       STATUS+0, 2 
	GOTO        L_SendSystemReset108
;PIC_Client.c,738 :: 		Delay_Ms(1);
	MOVLW       11
	MOVWF       R12, 0
	MOVLW       98
	MOVWF       R13, 0
L_SendSystemReset117:
	DECFSZ      R13, 1, 1
	BRA         L_SendSystemReset117
	DECFSZ      R12, 1, 1
	BRA         L_SendSystemReset117
	NOP
;PIC_Client.c,740 :: 		} //end SendSystemReset
L_end_SendSystemReset:
	RETURN      0
; end of _SendSystemReset

_ReadReg:

;PIC_Client.c,760 :: 		unsigned ReadReg(unsigned short int wAddress) {
;PIC_Client.c,767 :: 		vBank = ((unsigned char) wAddress) & 0xE0;
	MOVLW       224
	ANDWF       FARG_ReadReg_wAddress+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       ReadReg_vBank_L1+0 
;PIC_Client.c,768 :: 		if (vBank <= (0x3u << 5)) {
	MOVF        R1, 0 
	SUBLW       96
	BTFSS       STATUS+0, 0 
	GOTO        L_ReadReg118
;PIC_Client.c,769 :: 		if (vBank != vCurrentBank) {
	MOVF        ReadReg_vBank_L1+0, 0 
	XORWF       _vCurrentBank+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_ReadReg119
;PIC_Client.c,770 :: 		if (vBank == (0x0u << 5))
	MOVF        ReadReg_vBank_L1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadReg120
;PIC_Client.c,771 :: 		Execute0(B0SEL);
	MOVLW       192
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_ReadReg121
L_ReadReg120:
;PIC_Client.c,772 :: 		else if (vBank == (0x1u << 5))
	MOVF        ReadReg_vBank_L1+0, 0 
	XORLW       32
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadReg122
;PIC_Client.c,773 :: 		Execute0(B1SEL);
	MOVLW       194
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_ReadReg123
L_ReadReg122:
;PIC_Client.c,774 :: 		else if (vBank == (0x2u << 5))
	MOVF        ReadReg_vBank_L1+0, 0 
	XORLW       64
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadReg124
;PIC_Client.c,775 :: 		Execute0(B2SEL);
	MOVLW       196
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_ReadReg125
L_ReadReg124:
;PIC_Client.c,776 :: 		else if (vBank == (0x3u << 5))
	MOVF        ReadReg_vBank_L1+0, 0 
	XORLW       96
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadReg126
;PIC_Client.c,777 :: 		Execute0(B3SEL);
	MOVLW       198
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
L_ReadReg126:
L_ReadReg125:
L_ReadReg123:
L_ReadReg121:
;PIC_Client.c,779 :: 		vCurrentBank = vBank;
	MOVF        ReadReg_vBank_L1+0, 0 
	MOVWF       _vCurrentBank+0 
;PIC_Client.c,780 :: 		}
L_ReadReg119:
;PIC_Client.c,782 :: 		w = Execute2(RCR | (wAddress & 0x1F), 0x0000);
	MOVLW       31
	ANDWF       FARG_ReadReg_wAddress+0, 0 
	MOVWF       FARG_Execute2_vOpcode+0 
	CLRF        FARG_Execute2_wData+0 
	CLRF        FARG_Execute2_wData+1 
	CALL        _Execute2+0, 0
	MOVF        R0, 0 
	MOVWF       ReadReg_w_L1+0 
	MOVF        R1, 0 
	MOVWF       ReadReg_w_L1+1 
;PIC_Client.c,783 :: 		} else {
	GOTO        L_ReadReg127
L_ReadReg118:
;PIC_Client.c,784 :: 		unsigned long dw = Execute3(RCRU, (unsigned short int) wAddress);
	MOVLW       32
	MOVWF       FARG_Execute3_vOpcode+0 
	MOVF        FARG_ReadReg_wAddress+0, 0 
	MOVWF       FARG_Execute3_dwData+0 
	MOVLW       0
	MOVWF       FARG_Execute3_dwData+1 
	MOVWF       FARG_Execute3_dwData+2 
	MOVWF       FARG_Execute3_dwData+3 
	CALL        _Execute3+0, 0
	MOVF        R0, 0 
	MOVWF       ReadReg_dw_L2+0 
	MOVF        R1, 0 
	MOVWF       ReadReg_dw_L2+1 
	MOVF        R2, 0 
	MOVWF       ReadReg_dw_L2+2 
	MOVF        R3, 0 
	MOVWF       ReadReg_dw_L2+3 
;PIC_Client.c,785 :: 		((unsigned char * ) & w)[0] = ((unsigned char * ) & dw)[1];
	MOVF        ReadReg_dw_L2+1, 0 
	MOVWF       ReadReg_w_L1+0 
;PIC_Client.c,786 :: 		((unsigned char * ) & w)[1] = ((unsigned char * ) & dw)[2];
	MOVF        ReadReg_dw_L2+2, 0 
	MOVWF       ReadReg_w_L1+1 
;PIC_Client.c,787 :: 		}
L_ReadReg127:
;PIC_Client.c,789 :: 		return w;
	MOVF        ReadReg_w_L1+0, 0 
	MOVWF       R0 
	MOVF        ReadReg_w_L1+1, 0 
	MOVWF       R1 
;PIC_Client.c,791 :: 		} //end ReadReg
L_end_ReadReg:
	RETURN      0
; end of _ReadReg

_ReadMemoryWindow:

;PIC_Client.c,817 :: 		void ReadMemoryWindow(unsigned short vWindow, unsigned short * vData, unsigned wLength) {
;PIC_Client.c,820 :: 		vOpcode = RBMUDA;
	MOVLW       48
	MOVWF       ReadMemoryWindow_vOpcode_L0+0 
;PIC_Client.c,821 :: 		if (vWindow == GP_WINDOW)
	MOVF        FARG_ReadMemoryWindow_vWindow+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadMemoryWindow128
;PIC_Client.c,822 :: 		vOpcode = RBMGP;
	MOVLW       40
	MOVWF       ReadMemoryWindow_vOpcode_L0+0 
L_ReadMemoryWindow128:
;PIC_Client.c,823 :: 		if (vWindow == RX_WINDOW)
	MOVF        FARG_ReadMemoryWindow_vWindow+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadMemoryWindow129
;PIC_Client.c,824 :: 		vOpcode = RBMRX;
	MOVLW       44
	MOVWF       ReadMemoryWindow_vOpcode_L0+0 
L_ReadMemoryWindow129:
;PIC_Client.c,826 :: 		ReadN(vOpcode, vData, wLength);
	MOVF        ReadMemoryWindow_vOpcode_L0+0, 0 
	MOVWF       FARG_ReadN_vOpcode+0 
	MOVF        FARG_ReadMemoryWindow_vData+0, 0 
	MOVWF       FARG_ReadN_vData+0 
	MOVF        FARG_ReadMemoryWindow_vData+1, 0 
	MOVWF       FARG_ReadN_vData+1 
	MOVF        FARG_ReadMemoryWindow_wLength+0, 0 
	MOVWF       FARG_ReadN_wDataLen+0 
	MOVF        FARG_ReadMemoryWindow_wLength+1, 0 
	MOVWF       FARG_ReadN_wDataLen+1 
	CALL        _ReadN+0, 0
;PIC_Client.c,827 :: 		}
L_end_ReadMemoryWindow:
	RETURN      0
; end of _ReadMemoryWindow

_ReadN:

;PIC_Client.c,829 :: 		void ReadN(unsigned char vOpcode, unsigned char * vData, unsigned wDataLen) {
;PIC_Client.c,832 :: 		AssertChipSelect();
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,833 :: 		ClearSPIDoneFlag();
	BCF         PIR1+0, 3 
;PIC_Client.c,834 :: 		SSPBUF = vOpcode; // Send the command/opcode
	MOVF        FARG_ReadN_vOpcode+0, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,835 :: 		WaitForDatabyte();
L_ReadN139:
	BTFSC       PIR1+0, 3 
	GOTO        L_ReadN140
	GOTO        L_ReadN139
L_ReadN140:
	BCF         PIR1+0, 3 
;PIC_Client.c,836 :: 		vDummy = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R2 
;PIC_Client.c,837 :: 		while (wDataLen--) {
L_ReadN141:
	MOVF        FARG_ReadN_wDataLen+0, 0 
	MOVWF       R0 
	MOVF        FARG_ReadN_wDataLen+1, 0 
	MOVWF       R1 
	MOVLW       1
	SUBWF       FARG_ReadN_wDataLen+0, 1 
	MOVLW       0
	SUBWFB      FARG_ReadN_wDataLen+1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_ReadN142
;PIC_Client.c,838 :: 		SSPBUF = 0x00;
	CLRF        SSP1BUF+0 
;PIC_Client.c,839 :: 		WaitForDatabyte(); * vData = SSPBUF;
L_ReadN146:
	BTFSC       PIR1+0, 3 
	GOTO        L_ReadN147
	GOTO        L_ReadN146
L_ReadN147:
	BCF         PIR1+0, 3 
	MOVFF       FARG_ReadN_vData+0, FSR1
	MOVFF       FARG_ReadN_vData+1, FSR1H
	MOVF        SSP1BUF+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,840 :: 		vData++;
	INFSNZ      FARG_ReadN_vData+0, 1 
	INCF        FARG_ReadN_vData+1, 1 
;PIC_Client.c,841 :: 		}
	GOTO        L_ReadN141
L_ReadN142:
;PIC_Client.c,842 :: 		DeassertChipSelect();
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,845 :: 		}
L_end_ReadN:
	RETURN      0
; end of _ReadN

_ReadPHYReg:

;PIC_Client.c,864 :: 		unsigned ReadPHYReg(unsigned char Register) {
;PIC_Client.c,868 :: 		WriteReg(MIREGADR, 0x0100 | Register);
	MOVLW       84
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       0
	IORWF       FARG_ReadPHYReg_Register+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       0
	IORLW       1
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,869 :: 		WriteReg(MICMD, MICMD_MIIRD);
	MOVLW       82
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       1
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       0
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,873 :: 		while (ReadReg(MISTAT) & MISTAT_BUSY);
L_ReadPHYReg151:
	MOVLW       106
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	BTFSS       R0, 0 
	GOTO        L_ReadPHYReg152
	GOTO        L_ReadPHYReg151
L_ReadPHYReg152:
;PIC_Client.c,876 :: 		WriteReg(MICMD, 0x0000);
	MOVLW       82
	MOVWF       FARG_WriteReg_wAddress+0 
	CLRF        FARG_WriteReg_wValue+0 
	CLRF        FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,879 :: 		wResult = ReadReg(MIRD);
	MOVLW       104
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
;PIC_Client.c,881 :: 		return wResult;
;PIC_Client.c,882 :: 		} //end ReadPHYReg
L_end_ReadPHYReg:
	RETURN      0
; end of _ReadPHYReg

_WriteReg:

;PIC_Client.c,902 :: 		void WriteReg(unsigned short int wAddress, unsigned wValue) {
;PIC_Client.c,908 :: 		vBank = ((unsigned char) wAddress) & 0xE0;
	MOVLW       224
	ANDWF       FARG_WriteReg_wAddress+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       WriteReg_vBank_L1+0 
;PIC_Client.c,909 :: 		if (vBank <= (0x3u << 5)) {
	MOVF        R1, 0 
	SUBLW       96
	BTFSS       STATUS+0, 0 
	GOTO        L_WriteReg153
;PIC_Client.c,910 :: 		if (vBank != vCurrentBank) {
	MOVF        WriteReg_vBank_L1+0, 0 
	XORWF       _vCurrentBank+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_WriteReg154
;PIC_Client.c,911 :: 		if (vBank == (0x0u << 5))
	MOVF        WriteReg_vBank_L1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteReg155
;PIC_Client.c,912 :: 		Execute0(B0SEL);
	MOVLW       192
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_WriteReg156
L_WriteReg155:
;PIC_Client.c,913 :: 		else if (vBank == (0x1u << 5))
	MOVF        WriteReg_vBank_L1+0, 0 
	XORLW       32
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteReg157
;PIC_Client.c,914 :: 		Execute0(B1SEL);
	MOVLW       194
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_WriteReg158
L_WriteReg157:
;PIC_Client.c,915 :: 		else if (vBank == (0x2u << 5))
	MOVF        WriteReg_vBank_L1+0, 0 
	XORLW       64
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteReg159
;PIC_Client.c,916 :: 		Execute0(B2SEL);
	MOVLW       196
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_WriteReg160
L_WriteReg159:
;PIC_Client.c,917 :: 		else if (vBank == (0x3u << 5))
	MOVF        WriteReg_vBank_L1+0, 0 
	XORLW       96
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteReg161
;PIC_Client.c,918 :: 		Execute0(B3SEL);
	MOVLW       198
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
L_WriteReg161:
L_WriteReg160:
L_WriteReg158:
L_WriteReg156:
;PIC_Client.c,920 :: 		vCurrentBank = vBank;
	MOVF        WriteReg_vBank_L1+0, 0 
	MOVWF       _vCurrentBank+0 
;PIC_Client.c,921 :: 		}
L_WriteReg154:
;PIC_Client.c,923 :: 		Execute2(WCR | (wAddress & 0x1F), wValue);
	MOVLW       31
	ANDWF       FARG_WriteReg_wAddress+0, 0 
	MOVWF       R0 
	MOVLW       64
	IORWF       R0, 0 
	MOVWF       FARG_Execute2_vOpcode+0 
	MOVF        FARG_WriteReg_wValue+0, 0 
	MOVWF       FARG_Execute2_wData+0 
	MOVF        FARG_WriteReg_wValue+1, 0 
	MOVWF       FARG_Execute2_wData+1 
	CALL        _Execute2+0, 0
;PIC_Client.c,924 :: 		} else {
	GOTO        L_WriteReg162
L_WriteReg153:
;PIC_Client.c,926 :: 		((unsigned char * ) & dw)[0] = (unsigned char) wAddress;
	MOVF        FARG_WriteReg_wAddress+0, 0 
	MOVWF       WriteReg_dw_L2+0 
;PIC_Client.c,927 :: 		((unsigned char * ) & dw)[1] = ((unsigned char * ) & wValue)[0];
	MOVF        FARG_WriteReg_wValue+0, 0 
	MOVWF       WriteReg_dw_L2+1 
;PIC_Client.c,928 :: 		((unsigned char * ) & dw)[2] = ((unsigned char * ) & wValue)[1];
	MOVF        FARG_WriteReg_wValue+1, 0 
	MOVWF       WriteReg_dw_L2+2 
;PIC_Client.c,929 :: 		Execute3(WCRU, dw);
	MOVLW       34
	MOVWF       FARG_Execute3_vOpcode+0 
	MOVF        WriteReg_dw_L2+0, 0 
	MOVWF       FARG_Execute3_dwData+0 
	MOVF        WriteReg_dw_L2+1, 0 
	MOVWF       FARG_Execute3_dwData+1 
	MOVF        WriteReg_dw_L2+2, 0 
	MOVWF       FARG_Execute3_dwData+2 
	MOVF        WriteReg_dw_L2+3, 0 
	MOVWF       FARG_Execute3_dwData+3 
	CALL        _Execute3+0, 0
;PIC_Client.c,930 :: 		}
L_WriteReg162:
;PIC_Client.c,933 :: 		} //end WriteReg
L_end_WriteReg:
	RETURN      0
; end of _WriteReg

_WriteMemoryWindow:

;PIC_Client.c,957 :: 		void WriteMemoryWindow(unsigned short vWindow, unsigned short * vData, unsigned wLength) {
;PIC_Client.c,960 :: 		vOpcode = WBMUDA;
	MOVLW       50
	MOVWF       WriteMemoryWindow_vOpcode_L0+0 
;PIC_Client.c,961 :: 		if (vWindow & GP_WINDOW)
	BTFSS       FARG_WriteMemoryWindow_vWindow+0, 1 
	GOTO        L_WriteMemoryWindow163
;PIC_Client.c,962 :: 		vOpcode = WBMGP;
	MOVLW       42
	MOVWF       WriteMemoryWindow_vOpcode_L0+0 
L_WriteMemoryWindow163:
;PIC_Client.c,963 :: 		if (vWindow & RX_WINDOW)
	BTFSS       FARG_WriteMemoryWindow_vWindow+0, 2 
	GOTO        L_WriteMemoryWindow164
;PIC_Client.c,964 :: 		vOpcode = WBMRX;
	MOVLW       46
	MOVWF       WriteMemoryWindow_vOpcode_L0+0 
L_WriteMemoryWindow164:
;PIC_Client.c,966 :: 		WriteN(vOpcode, vData, wLength);
	MOVF        WriteMemoryWindow_vOpcode_L0+0, 0 
	MOVWF       FARG_WriteN_vOpcode+0 
	MOVF        FARG_WriteMemoryWindow_vData+0, 0 
	MOVWF       FARG_WriteN_vData+0 
	MOVF        FARG_WriteMemoryWindow_vData+1, 0 
	MOVWF       FARG_WriteN_vData+1 
	MOVF        FARG_WriteMemoryWindow_wLength+0, 0 
	MOVWF       FARG_WriteN_wDataLen+0 
	MOVF        FARG_WriteMemoryWindow_wLength+1, 0 
	MOVWF       FARG_WriteN_wDataLen+1 
	CALL        _WriteN+0, 0
;PIC_Client.c,967 :: 		}
L_end_WriteMemoryWindow:
	RETURN      0
; end of _WriteMemoryWindow

_WriteN:

;PIC_Client.c,969 :: 		void WriteN(unsigned char vOpcode, unsigned short * vData, unsigned wDataLen) {
;PIC_Client.c,972 :: 		AssertChipSelect();
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,973 :: 		ClearSPIDoneFlag();
	BCF         PIR1+0, 3 
;PIC_Client.c,974 :: 		SSPBUF = vOpcode; // Send the command/opcode
	MOVF        FARG_WriteN_vOpcode+0, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,975 :: 		WaitForDatabyte();
L_WriteN174:
	BTFSC       PIR1+0, 3 
	GOTO        L_WriteN175
	GOTO        L_WriteN174
L_WriteN175:
	BCF         PIR1+0, 3 
;PIC_Client.c,976 :: 		vDummy = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R2 
;PIC_Client.c,978 :: 		while (wDataLen--) {
L_WriteN176:
	MOVF        FARG_WriteN_wDataLen+0, 0 
	MOVWF       R0 
	MOVF        FARG_WriteN_wDataLen+1, 0 
	MOVWF       R1 
	MOVLW       1
	SUBWF       FARG_WriteN_wDataLen+0, 1 
	MOVLW       0
	SUBWFB      FARG_WriteN_wDataLen+1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_WriteN177
;PIC_Client.c,979 :: 		SSPBUF = * vData++;
	MOVFF       FARG_WriteN_vData+0, FSR0
	MOVFF       FARG_WriteN_vData+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       SSP1BUF+0 
	INFSNZ      FARG_WriteN_vData+0, 1 
	INCF        FARG_WriteN_vData+1, 1 
;PIC_Client.c,980 :: 		WaitForDatabyte();
L_WriteN181:
	BTFSC       PIR1+0, 3 
	GOTO        L_WriteN182
	GOTO        L_WriteN181
L_WriteN182:
	BCF         PIR1+0, 3 
;PIC_Client.c,981 :: 		vDummy = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R2 
;PIC_Client.c,982 :: 		}
	GOTO        L_WriteN176
L_WriteN177:
;PIC_Client.c,983 :: 		DeassertChipSelect();
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,985 :: 		}
L_end_WriteN:
	RETURN      0
; end of _WriteN

_WritePHYReg:

;PIC_Client.c,1005 :: 		void WritePHYReg(unsigned char Register, unsigned short int Data) {
;PIC_Client.c,1007 :: 		WriteReg(MIREGADR, 0x0100 | Register);
	MOVLW       84
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       0
	IORWF       FARG_WritePHYReg_Register+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       0
	IORLW       1
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,1010 :: 		WriteReg(MIWR, Data);
	MOVLW       102
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVF        FARG_WritePHYReg_Data+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       0
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,1013 :: 		while (ReadReg(MISTAT) & MISTAT_BUSY);
L_WritePHYReg186:
	MOVLW       106
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	BTFSS       R0, 0 
	GOTO        L_WritePHYReg187
	GOTO        L_WritePHYReg186
L_WritePHYReg187:
;PIC_Client.c,1014 :: 		} //end WritePHYReg
L_end_WritePHYReg:
	RETURN      0
; end of _WritePHYReg

_BFSReg:

;PIC_Client.c,1033 :: 		void BFSReg(unsigned short int wAddress, unsigned short int wBitMask) {
;PIC_Client.c,1039 :: 		vBank = ((unsigned char) wAddress) & 0xE0;
	MOVLW       224
	ANDWF       FARG_BFSReg_wAddress+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       BFSReg_vBank_L1+0 
;PIC_Client.c,1040 :: 		if (vBank != vCurrentBank) {
	MOVF        R1, 0 
	XORWF       _vCurrentBank+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_BFSReg188
;PIC_Client.c,1041 :: 		if (vBank == (0x0u << 5))
	MOVF        BFSReg_vBank_L1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_BFSReg189
;PIC_Client.c,1042 :: 		Execute0(B0SEL);
	MOVLW       192
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_BFSReg190
L_BFSReg189:
;PIC_Client.c,1043 :: 		else if (vBank == (0x1u << 5))
	MOVF        BFSReg_vBank_L1+0, 0 
	XORLW       32
	BTFSS       STATUS+0, 2 
	GOTO        L_BFSReg191
;PIC_Client.c,1044 :: 		Execute0(B1SEL);
	MOVLW       194
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_BFSReg192
L_BFSReg191:
;PIC_Client.c,1045 :: 		else if (vBank == (0x2u << 5))
	MOVF        BFSReg_vBank_L1+0, 0 
	XORLW       64
	BTFSS       STATUS+0, 2 
	GOTO        L_BFSReg193
;PIC_Client.c,1046 :: 		Execute0(B2SEL);
	MOVLW       196
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_BFSReg194
L_BFSReg193:
;PIC_Client.c,1047 :: 		else if (vBank == (0x3u << 5))
	MOVF        BFSReg_vBank_L1+0, 0 
	XORLW       96
	BTFSS       STATUS+0, 2 
	GOTO        L_BFSReg195
;PIC_Client.c,1048 :: 		Execute0(B3SEL);
	MOVLW       198
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
L_BFSReg195:
L_BFSReg194:
L_BFSReg192:
L_BFSReg190:
;PIC_Client.c,1050 :: 		vCurrentBank = vBank;
	MOVF        BFSReg_vBank_L1+0, 0 
	MOVWF       _vCurrentBank+0 
;PIC_Client.c,1051 :: 		}
L_BFSReg188:
;PIC_Client.c,1053 :: 		Execute2(BFS | (wAddress & 0x1F), wBitMask);
	MOVLW       31
	ANDWF       FARG_BFSReg_wAddress+0, 0 
	MOVWF       R0 
	MOVLW       128
	IORWF       R0, 0 
	MOVWF       FARG_Execute2_vOpcode+0 
	MOVF        FARG_BFSReg_wBitMask+0, 0 
	MOVWF       FARG_Execute2_wData+0 
	MOVLW       0
	MOVWF       FARG_Execute2_wData+1 
	CALL        _Execute2+0, 0
;PIC_Client.c,1055 :: 		} //end BFSReg
L_end_BFSReg:
	RETURN      0
; end of _BFSReg

_BFCReg:

;PIC_Client.c,1057 :: 		void BFCReg(unsigned short int wAddress, unsigned short int wBitMask) {
;PIC_Client.c,1063 :: 		vBank = ((unsigned char) wAddress) & 0xE0;
	MOVLW       224
	ANDWF       FARG_BFCReg_wAddress+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       BFCReg_vBank_L1+0 
;PIC_Client.c,1064 :: 		if (vBank != vCurrentBank) {
	MOVF        R1, 0 
	XORWF       _vCurrentBank+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_BFCReg196
;PIC_Client.c,1065 :: 		if (vBank == (0x0u << 5))
	MOVF        BFCReg_vBank_L1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_BFCReg197
;PIC_Client.c,1066 :: 		Execute0(B0SEL);
	MOVLW       192
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_BFCReg198
L_BFCReg197:
;PIC_Client.c,1067 :: 		else if (vBank == (0x1u << 5))
	MOVF        BFCReg_vBank_L1+0, 0 
	XORLW       32
	BTFSS       STATUS+0, 2 
	GOTO        L_BFCReg199
;PIC_Client.c,1068 :: 		Execute0(B1SEL);
	MOVLW       194
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_BFCReg200
L_BFCReg199:
;PIC_Client.c,1069 :: 		else if (vBank == (0x2u << 5))
	MOVF        BFCReg_vBank_L1+0, 0 
	XORLW       64
	BTFSS       STATUS+0, 2 
	GOTO        L_BFCReg201
;PIC_Client.c,1070 :: 		Execute0(B2SEL);
	MOVLW       196
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_BFCReg202
L_BFCReg201:
;PIC_Client.c,1071 :: 		else if (vBank == (0x3u << 5))
	MOVF        BFCReg_vBank_L1+0, 0 
	XORLW       96
	BTFSS       STATUS+0, 2 
	GOTO        L_BFCReg203
;PIC_Client.c,1072 :: 		Execute0(B3SEL);
	MOVLW       198
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
L_BFCReg203:
L_BFCReg202:
L_BFCReg200:
L_BFCReg198:
;PIC_Client.c,1074 :: 		vCurrentBank = vBank;
	MOVF        BFCReg_vBank_L1+0, 0 
	MOVWF       _vCurrentBank+0 
;PIC_Client.c,1075 :: 		}
L_BFCReg196:
;PIC_Client.c,1077 :: 		Execute2(BFC | (wAddress & 0x1F), wBitMask);
	MOVLW       31
	ANDWF       FARG_BFCReg_wAddress+0, 0 
	MOVWF       R0 
	MOVLW       160
	IORWF       R0, 0 
	MOVWF       FARG_Execute2_vOpcode+0 
	MOVF        FARG_BFCReg_wBitMask+0, 0 
	MOVWF       FARG_Execute2_wData+0 
	MOVLW       0
	MOVWF       FARG_Execute2_wData+1 
	CALL        _Execute2+0, 0
;PIC_Client.c,1079 :: 		}
L_end_BFCReg:
	RETURN      0
; end of _BFCReg

_Execute0:

;PIC_Client.c,1097 :: 		void Execute0(unsigned char vOpcode) {
;PIC_Client.c,1100 :: 		AssertChipSelect();
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,1101 :: 		ClearSPIDoneFlag();
	BCF         PIR1+0, 3 
;PIC_Client.c,1102 :: 		SSPBUF = vOpcode; // Send the command/opcode
	MOVF        FARG_Execute0_vOpcode+0, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1103 :: 		WaitForDatabyte();
L_Execute0213:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute0214
	GOTO        L_Execute0213
L_Execute0214:
	BCF         PIR1+0, 3 
;PIC_Client.c,1104 :: 		vDummy = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R0 
;PIC_Client.c,1105 :: 		DeassertChipSelect();
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,1108 :: 		} //end Execute0
L_end_Execute0:
	RETURN      0
; end of _Execute0

_Execute2:

;PIC_Client.c,1110 :: 		unsigned Execute2(unsigned char vOpcode, unsigned wData) {
;PIC_Client.c,1113 :: 		AssertChipSelect();
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,1114 :: 		ClearSPIDoneFlag();
	BCF         PIR1+0, 3 
;PIC_Client.c,1115 :: 		SSPBUF = vOpcode; // Send the command/opcode
	MOVF        FARG_Execute2_vOpcode+0, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1116 :: 		WaitForDatabyte();
L_Execute2227:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute2228
	GOTO        L_Execute2227
L_Execute2228:
	BCF         PIR1+0, 3 
;PIC_Client.c,1117 :: 		((unsigned char * ) & wReturn)[0] = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R2 
;PIC_Client.c,1118 :: 		SSPBUF = ((unsigned char * ) & wData)[0]; // Send low unsigned char of data
	MOVF        FARG_Execute2_wData+0, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1119 :: 		WaitForDatabyte();
L_Execute2232:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute2233
	GOTO        L_Execute2232
L_Execute2233:
	BCF         PIR1+0, 3 
;PIC_Client.c,1120 :: 		((unsigned char * ) & wReturn)[0] = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R2 
;PIC_Client.c,1121 :: 		SSPBUF = ((unsigned char * ) & wData)[1]; // Send high unsigned char of data
	MOVF        FARG_Execute2_wData+1, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1122 :: 		WaitForDatabyte();
L_Execute2237:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute2238
	GOTO        L_Execute2237
L_Execute2238:
	BCF         PIR1+0, 3 
;PIC_Client.c,1123 :: 		((unsigned char * ) & wReturn)[1] = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R3 
;PIC_Client.c,1124 :: 		DeassertChipSelect();
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,1125 :: 		return wReturn;
	MOVF        R2, 0 
	MOVWF       R0 
	MOVF        R3, 0 
	MOVWF       R1 
;PIC_Client.c,1126 :: 		} //end Execute2
L_end_Execute2:
	RETURN      0
; end of _Execute2

_Execute3:

;PIC_Client.c,1128 :: 		unsigned long Execute3(unsigned char vOpcode, unsigned long dwData) {
;PIC_Client.c,1131 :: 		AssertChipSelect();
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,1132 :: 		ClearSPIDoneFlag();
	BCF         PIR1+0, 3 
;PIC_Client.c,1133 :: 		SSPBUF = vOpcode; // Send the command/opcode
	MOVF        FARG_Execute3_vOpcode+0, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1134 :: 		((unsigned char * ) & dwReturn)[3] = 0x00;
	CLRF        R7 
;PIC_Client.c,1135 :: 		WaitForDatabyte();
L_Execute3251:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute3252
	GOTO        L_Execute3251
L_Execute3252:
	BCF         PIR1+0, 3 
;PIC_Client.c,1136 :: 		((unsigned char * ) & dwReturn)[0] = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R4 
;PIC_Client.c,1137 :: 		SSPBUF = ((unsigned char * ) & dwData)[0]; // Send unsigned char 0 of data
	MOVF        FARG_Execute3_dwData+0, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1138 :: 		WaitForDatabyte();
L_Execute3256:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute3257
	GOTO        L_Execute3256
L_Execute3257:
	BCF         PIR1+0, 3 
;PIC_Client.c,1139 :: 		((unsigned char * ) & dwReturn)[0] = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R4 
;PIC_Client.c,1140 :: 		SSPBUF = ((unsigned char * ) & dwData)[1]; // Send unsigned char 1 of data
	MOVF        FARG_Execute3_dwData+1, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1141 :: 		WaitForDatabyte();
L_Execute3261:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute3262
	GOTO        L_Execute3261
L_Execute3262:
	BCF         PIR1+0, 3 
;PIC_Client.c,1142 :: 		((unsigned char * ) & dwReturn)[1] = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R5 
;PIC_Client.c,1143 :: 		SSPBUF = ((unsigned char * ) & dwData)[2]; // Send unsigned char 2 of data
	MOVF        FARG_Execute3_dwData+2, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1144 :: 		WaitForDatabyte();
L_Execute3266:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute3267
	GOTO        L_Execute3266
L_Execute3267:
	BCF         PIR1+0, 3 
;PIC_Client.c,1145 :: 		((unsigned char * ) & dwReturn)[2] = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R6 
;PIC_Client.c,1146 :: 		DeassertChipSelect();
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,1148 :: 		return dwReturn;
	MOVF        R4, 0 
	MOVWF       R0 
	MOVF        R5, 0 
	MOVWF       R1 
	MOVF        R6, 0 
	MOVWF       R2 
	MOVF        R7, 0 
	MOVWF       R3 
;PIC_Client.c,1149 :: 		} //end Execute2
L_end_Execute3:
	RETURN      0
; end of _Execute3

_WriteReg_Hex:

;PIC_Client.c,1153 :: 		void WriteReg_Hex(unsigned char * kommandoTekst, unsigned char Register) {
;PIC_Client.c,1154 :: 		strcpy(buffer, kommandoTekst);
	MOVLW       _buffer+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_strcpy_to+1 
	MOVF        FARG_WriteReg_Hex_kommandoTekst+0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        FARG_WriteReg_Hex_kommandoTekst+1, 0 
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;PIC_Client.c,1155 :: 		WordtoHex(ReadReg(Register), HexStr);
	MOVF        FARG_WriteReg_Hex_Register+0, 0 
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_WordToHex_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_WordToHex_input+1 
	MOVLW       _HexStr+0
	MOVWF       FARG_WordToHex_output+0 
	MOVLW       hi_addr(_HexStr+0)
	MOVWF       FARG_WordToHex_output+1 
	CALL        _WordToHex+0, 0
;PIC_Client.c,1156 :: 		strcat(buffer, HexStr);
	MOVLW       _buffer+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       _HexStr+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(_HexStr+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;PIC_Client.c,1157 :: 		UART1_Write_Text(buffer);
	MOVLW       _buffer+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1158 :: 		}
L_end_WriteReg_Hex:
	RETURN      0
; end of _WriteReg_Hex

_ENC100DumpState:

;PIC_Client.c,1160 :: 		void ENC100DumpState(void) {
;PIC_Client.c,1161 :: 		strcpy(buffer, "\r\n  Next Packet Pointer    = 0x");
	MOVLW       _buffer+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr31_PIC_Client+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr31_PIC_Client+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;PIC_Client.c,1162 :: 		WordtoHex(NextPacketPointer, HexStr);
	MOVF        _NextPacketPointer+0, 0 
	MOVWF       FARG_WordToHex_input+0 
	MOVF        _NextPacketPointer+1, 0 
	MOVWF       FARG_WordToHex_input+1 
	MOVLW       _HexStr+0
	MOVWF       FARG_WordToHex_output+0 
	MOVLW       hi_addr(_HexStr+0)
	MOVWF       FARG_WordToHex_output+1 
	CALL        _WordToHex+0, 0
;PIC_Client.c,1163 :: 		strcat(buffer, HexStr);
	MOVLW       _buffer+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       _HexStr+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(_HexStr+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;PIC_Client.c,1164 :: 		UART1_Write_Text(buffer);
	MOVLW       _buffer+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1165 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr32_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr32_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1166 :: 		WriteReg_Hex("\r\n EIR     = 0x", EIR);
	MOVLW       ?lstr33_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr33_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       28
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1168 :: 		WriteReg_Hex("\r\n ERXST   = 0x", ERXST);
	MOVLW       ?lstr34_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr34_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       4
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1169 :: 		WriteReg_Hex("\r\n ERXRDPT = 0x", ERXRDPT);
	MOVLW       ?lstr35_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr35_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       138
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1170 :: 		WriteReg_Hex("\r\n ERXWRPT = 0x", ERXWRPT);
	MOVLW       ?lstr36_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr36_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       140
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1171 :: 		WriteReg_Hex("\r\n ERXTAIL = 0x", ERXTAIL);
	MOVLW       ?lstr37_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr37_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       6
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1172 :: 		WriteReg_Hex("\r\n ERXHEAD = 0x", ERXHEAD);
	MOVLW       ?lstr38_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr38_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       8
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1173 :: 		WriteReg_Hex("\r\n ESTAT   = 0x", ESTAT);
	MOVLW       ?lstr39_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr39_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       26
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1174 :: 		WriteReg_Hex("\r\n ERXFCON = 0x", ERXFCON);
	MOVLW       ?lstr40_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr40_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       52
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1175 :: 		WriteReg_Hex("\r\n MACON1  = 0x", MACON1);
	MOVLW       ?lstr41_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr41_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       64
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1176 :: 		WriteReg_Hex("\r\n MACON2  = 0x", MACON2);
	MOVLW       ?lstr42_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr42_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       66
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1177 :: 		WriteReg_Hex("\r\n ECON1   = 0x", ECON1);
	MOVLW       ?lstr43_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr43_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       30
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1178 :: 		WriteReg_Hex("\r\n ECON2   = 0x", ECON2);
	MOVLW       ?lstr44_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr44_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       110
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1179 :: 		WriteReg_Hex("\r\n ETXST   = 0x", ETXST);
	MOVLW       ?lstr45_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr45_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	CLRF        FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1180 :: 		WriteReg_Hex("\r\n ETXLEN  = 0x", ETXLEN);
	MOVLW       ?lstr46_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr46_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       2
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1181 :: 		WriteReg_Hex("\r\n EDMAST  = 0x", EDMAST);
	MOVLW       ?lstr47_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr47_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       10
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1182 :: 		WriteReg_Hex("\r\n EDMALEN = 0x", EDMALEN);
	MOVLW       ?lstr48_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr48_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       12
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1183 :: 		WriteReg_Hex("\r\n EDMADST = 0x", EDMADST);
	MOVLW       ?lstr49_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr49_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       14
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1184 :: 		WriteReg_Hex("\r\n EDMACS  = 0x", EDMACS);
	MOVLW       ?lstr50_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr50_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       16
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1185 :: 		WriteReg_Hex("\r\n MAADR3  = 0x", MAADR3);
	MOVLW       ?lstr51_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr51_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       96
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1186 :: 		WriteReg_Hex("\r\n MAADR2  = 0x", MAADR2);
	MOVLW       ?lstr52_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr52_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       98
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1187 :: 		WriteReg_Hex("\r\n MAADR1  = 0x", MAADR1);
	MOVLW       ?lstr53_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr53_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       100
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1189 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr54_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr54_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1190 :: 		}
L_end_ENC100DumpState:
	RETURN      0
; end of _ENC100DumpState

_ShowPacket:

;PIC_Client.c,1192 :: 		void ShowPacket(unsigned short * Buffer, unsigned len) {
;PIC_Client.c,1196 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr55_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr55_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1197 :: 		LinI = 0x00;
	CLRF        ShowPacket_LinI_L0+0 
	CLRF        ShowPacket_LinI_L0+1 
;PIC_Client.c,1198 :: 		for (PacI = 0; PacI < len; ++PacI) {
	CLRF        ShowPacket_PacI_L0+0 
	CLRF        ShowPacket_PacI_L0+1 
L_ShowPacket271:
	MOVF        FARG_ShowPacket_len+1, 0 
	SUBWF       ShowPacket_PacI_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ShowPacket338
	MOVF        FARG_ShowPacket_len+0, 0 
	SUBWF       ShowPacket_PacI_L0+0, 0 
L__ShowPacket338:
	BTFSC       STATUS+0, 0 
	GOTO        L_ShowPacket272
;PIC_Client.c,1199 :: 		ByteToHex(Buffer[PacI], tal);
	MOVF        ShowPacket_PacI_L0+0, 0 
	ADDWF       FARG_ShowPacket_Buffer+0, 0 
	MOVWF       FSR0 
	MOVF        ShowPacket_PacI_L0+1, 0 
	ADDWFC      FARG_ShowPacket_Buffer+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ByteToHex_input+0 
	MOVLW       ShowPacket_tal_L0+0
	MOVWF       FARG_ByteToHex_output+0 
	MOVLW       hi_addr(ShowPacket_tal_L0+0)
	MOVWF       FARG_ByteToHex_output+1 
	CALL        _ByteToHex+0, 0
;PIC_Client.c,1200 :: 		UART1_Write_Text(tal);
	MOVLW       ShowPacket_tal_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(ShowPacket_tal_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1201 :: 		UART1_Write_Text(" ");
	MOVLW       ?lstr56_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr56_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1202 :: 		if (++LinI == 0x10) {
	INFSNZ      ShowPacket_LinI_L0+0, 1 
	INCF        ShowPacket_LinI_L0+1, 1 
	MOVLW       0
	XORWF       ShowPacket_LinI_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ShowPacket339
	MOVLW       16
	XORWF       ShowPacket_LinI_L0+0, 0 
L__ShowPacket339:
	BTFSS       STATUS+0, 2 
	GOTO        L_ShowPacket274
;PIC_Client.c,1203 :: 		LinI = 0x00;
	CLRF        ShowPacket_LinI_L0+0 
	CLRF        ShowPacket_LinI_L0+1 
;PIC_Client.c,1204 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr57_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr57_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1205 :: 		}
L_ShowPacket274:
;PIC_Client.c,1198 :: 		for (PacI = 0; PacI < len; ++PacI) {
	INFSNZ      ShowPacket_PacI_L0+0, 1 
	INCF        ShowPacket_PacI_L0+1, 1 
;PIC_Client.c,1206 :: 		}
	GOTO        L_ShowPacket271
L_ShowPacket272:
;PIC_Client.c,1207 :: 		UART1_Write_Text("\n\r");
	MOVLW       ?lstr58_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr58_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1208 :: 		}
L_end_ShowPacket:
	RETURN      0
; end of _ShowPacket

_ClrPacket:

;PIC_Client.c,1210 :: 		void ClrPacket() {
;PIC_Client.c,1212 :: 		Len = 200;
	MOVLW       200
	MOVWF       R2 
	MOVLW       0
	MOVWF       R3 
;PIC_Client.c,1213 :: 		do {
L_ClrPacket275:
;PIC_Client.c,1214 :: 		Packet[Len] = 0;
	MOVLW       _Packet+0
	ADDWF       R2, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_Packet+0)
	ADDWFC      R3, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,1215 :: 		} while (Len--);
	MOVF        R2, 0 
	MOVWF       R0 
	MOVF        R3, 0 
	MOVWF       R1 
	MOVLW       1
	SUBWF       R2, 1 
	MOVLW       0
	SUBWFB      R3, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_ClrPacket275
;PIC_Client.c,1216 :: 		}
L_end_ClrPacket:
	RETURN      0
; end of _ClrPacket
