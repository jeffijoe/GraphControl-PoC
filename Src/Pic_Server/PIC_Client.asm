
_main:

;PIC_Client.c,12 :: 		void main() {
;PIC_Client.c,16 :: 		int i = 0, lessThan = 0, moreThan = 0, oldadc_rd = 0;
	CLRF        main_lessThan_L0+0 
	CLRF        main_lessThan_L0+1 
	CLRF        main_moreThan_L0+0 
	CLRF        main_moreThan_L0+1 
	CLRF        main_oldadc_rd_L0+0 
	CLRF        main_oldadc_rd_L0+1 
;PIC_Client.c,18 :: 		ANSELA = 0x02;             // Configure RA1 pin as analog
	MOVLW       2
	MOVWF       ANSELA+0 
;PIC_Client.c,19 :: 		ANSELC = 0;
	CLRF        ANSELC+0 
;PIC_Client.c,20 :: 		ANSELD = 0;
	CLRF        ANSELD+0 
;PIC_Client.c,21 :: 		TRISD = 0;
	CLRF        TRISD+0 
;PIC_Client.c,22 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	MOVLW       3
	MOVWF       SPBRGH+0 
	MOVLW       64
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;PIC_Client.c,23 :: 		Delay_ms(100);
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
;PIC_Client.c,24 :: 		UART1_Write_Text("\n\rStart \n\r");
	MOVLW       ?lstr1_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,25 :: 		MACInit(void);
	CALL        _MACInit+0, 0
;PIC_Client.c,26 :: 		Delay_ms(100);
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
;PIC_Client.c,27 :: 		ChkLink();
	CALL        _ChkLink+0, 0
;PIC_Client.c,29 :: 		do {
L_main2:
;PIC_Client.c,30 :: 		adc_rd = ADC_Read(1);    // get ADC value from 1st channel
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _adc_rd+0 
	MOVF        R1, 0 
	MOVWF       _adc_rd+1 
;PIC_Client.c,32 :: 		lessThan = oldadc_rd - FluxLimit;
	MOVLW       10
	SUBWF       main_oldadc_rd_L0+0, 0 
	MOVWF       main_lessThan_L0+0 
	MOVLW       0
	SUBWFB      main_oldadc_rd_L0+1, 0 
	MOVWF       main_lessThan_L0+1 
;PIC_Client.c,33 :: 		moreThan = oldadc_rd + FluxLimit;
	MOVLW       10
	ADDWF       main_oldadc_rd_L0+0, 0 
	MOVWF       main_moreThan_L0+0 
	MOVLW       0
	ADDWFC      main_oldadc_rd_L0+1, 0 
	MOVWF       main_moreThan_L0+1 
;PIC_Client.c,35 :: 		if (ChkPck()) {
	CALL        _ChkPck+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main5
;PIC_Client.c,37 :: 		arpData = (PArpStruct) Packet;
	MOVLW       _Packet+0
	MOVWF       main_arpData_L0+0 
	MOVLW       hi_addr(_Packet+0)
	MOVWF       main_arpData_L0+1 
;PIC_Client.c,38 :: 		if (arpData->eth.Type == 0x0608) // Arp Request = 0x0806
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
;PIC_Client.c,40 :: 		if (!HandleArpPackage(arpData))
	MOVF        main_arpData_L0+0, 0 
	MOVWF       FARG_HandleArpPackage_arpData+0 
	MOVF        main_arpData_L0+1, 0 
	MOVWF       FARG_HandleArpPackage_arpData+1 
	CALL        _HandleArpPackage+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main7
;PIC_Client.c,42 :: 		UART1_Write_Text("Ukendt device");
	MOVLW       ?lstr2_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,43 :: 		}
L_main7:
;PIC_Client.c,44 :: 		}
	GOTO        L_main8
L_main6:
;PIC_Client.c,46 :: 		else if (arpData->eth.Type == 0x0008) // IP = 0x0800
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
;PIC_Client.c,48 :: 		ipData = (PIpStruct) Packet;
	MOVLW       _Packet+0
	MOVWF       main_ipData_L0+0 
	MOVLW       hi_addr(_Packet+0)
	MOVWF       main_ipData_L0+1 
;PIC_Client.c,49 :: 		if (IsThisDevice(ipData->Ip.DestAddr)) {
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
;PIC_Client.c,50 :: 		switch (ipData->Ip.Proto)
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
;PIC_Client.c,52 :: 		case PROTO_ICMP:
L_main13:
;PIC_Client.c,53 :: 		Icmp((PIcmpStruct) Packet, PckLen);
	MOVLW       _Packet+0
	MOVWF       FARG_Icmp_PIcmpData+0 
	MOVLW       hi_addr(_Packet+0)
	MOVWF       FARG_Icmp_PIcmpData+1 
	MOVF        _PckLen+0, 0 
	MOVWF       FARG_Icmp_PckLen+0 
	CALL        _Icmp+0, 0
;PIC_Client.c,54 :: 		break;
	GOTO        L_main12
;PIC_Client.c,55 :: 		case PROTO_UDP:
L_main14:
;PIC_Client.c,56 :: 		HandleUdpPackage((PUdpStruct) Packet);
	MOVLW       _Packet+0
	MOVWF       FARG_HandleUdpPackage_udpData+0 
	MOVLW       hi_addr(_Packet+0)
	MOVWF       FARG_HandleUdpPackage_udpData+1 
	CALL        _HandleUdpPackage+0, 0
;PIC_Client.c,57 :: 		break;
	GOTO        L_main12
;PIC_Client.c,58 :: 		case PROTO_TCP:
L_main15:
;PIC_Client.c,59 :: 		HandleTcpPackage((PTcpStruct) Packet);
	MOVLW       _Packet+0
	MOVWF       FARG_HandleTcpPackage_tcpData+0 
	MOVLW       hi_addr(_Packet+0)
	MOVWF       FARG_HandleTcpPackage_tcpData+1 
	CALL        _HandleTcpPackage+0, 0
;PIC_Client.c,60 :: 		break;
	GOTO        L_main12
;PIC_Client.c,61 :: 		}
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
;PIC_Client.c,62 :: 		}
L_main10:
;PIC_Client.c,63 :: 		}
L_main9:
L_main8:
;PIC_Client.c,64 :: 		}
	GOTO        L_main16
L_main5:
;PIC_Client.c,65 :: 		else if (destinationPort != 0 && (lessThan > adc_rd || moreThan < adc_rd))
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
;PIC_Client.c,67 :: 		oldadc_rd = adc_rd;
	MOVF        _adc_rd+0, 0 
	MOVWF       main_oldadc_rd_L0+0 
	MOVF        _adc_rd+1, 0 
	MOVWF       main_oldadc_rd_L0+1 
;PIC_Client.c,68 :: 		UART1_Write_Text("\n\rStart sending packet!\n\r");
	MOVLW       ?lstr3_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,69 :: 		TcpData = (PTcpStruct)Packet;
	MOVLW       _Packet+0
	MOVWF       _TcpData+0 
	MOVLW       hi_addr(_Packet+0)
	MOVWF       _TcpData+1 
;PIC_Client.c,70 :: 		SendMessage((PTcpStruct) TcpData);
	MOVF        _TcpData+0, 0 
	MOVWF       FARG_SendMessage_TcpData+0 
	MOVF        _TcpData+1, 0 
	MOVWF       FARG_SendMessage_TcpData+1 
	CALL        _SendMessage+0, 0
;PIC_Client.c,71 :: 		UART1_Write_Text("\n\rFinished sending packet!\n\r");
	MOVLW       ?lstr4_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,72 :: 		}
L_main21:
L_main16:
;PIC_Client.c,73 :: 		} while (true);
	GOTO        L_main2
;PIC_Client.c,74 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_PrintIpAddr:

;PIC_Client.c,76 :: 		char* PrintIpAddr(unsigned short address[4])
;PIC_Client.c,79 :: 		sprintf(buffer, "%d . %d . %d . %d\0", (int)address[0], (int)address[1], (int)address[2], (int)address[3]);
	MOVLW       PrintIpAddr_buffer_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(PrintIpAddr_buffer_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_5_PIC_Client+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_5_PIC_Client+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_5_PIC_Client+0)
	MOVWF       FARG_sprintf_f+2 
	MOVFF       FARG_PrintIpAddr_address+0, FSR0
	MOVFF       FARG_PrintIpAddr_address+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+6 
	MOVLW       1
	ADDWF       FARG_PrintIpAddr_address+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_PrintIpAddr_address+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+8 
	MOVLW       2
	ADDWF       FARG_PrintIpAddr_address+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_PrintIpAddr_address+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+9 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+10 
	MOVLW       3
	ADDWF       FARG_PrintIpAddr_address+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_PrintIpAddr_address+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+11 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+12 
	CALL        _sprintf+0, 0
;PIC_Client.c,80 :: 		return buffer;
	MOVLW       PrintIpAddr_buffer_L0+0
	MOVWF       R0 
	MOVLW       hi_addr(PrintIpAddr_buffer_L0+0)
	MOVWF       R1 
;PIC_Client.c,81 :: 		}
L_end_PrintIpAddr:
	RETURN      0
; end of _PrintIpAddr

_PrintMacAddr:

;PIC_Client.c,83 :: 		char* PrintMacAddr(unsigned short address[6])
;PIC_Client.c,86 :: 		sprintf(buffer, "%x : %x : %x : %x : %x : %x\0",
	MOVLW       PrintMacAddr_buffer_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(PrintMacAddr_buffer_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_6_PIC_Client+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_6_PIC_Client+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_6_PIC_Client+0)
	MOVWF       FARG_sprintf_f+2 
;PIC_Client.c,87 :: 		(int)address[0], (int)address[1], (int)address[2], (int)address[3], (int)address[4], (int)address[5]);
	MOVFF       FARG_PrintMacAddr_address+0, FSR0
	MOVFF       FARG_PrintMacAddr_address+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+6 
	MOVLW       1
	ADDWF       FARG_PrintMacAddr_address+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_PrintMacAddr_address+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+8 
	MOVLW       2
	ADDWF       FARG_PrintMacAddr_address+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_PrintMacAddr_address+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+9 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+10 
	MOVLW       3
	ADDWF       FARG_PrintMacAddr_address+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_PrintMacAddr_address+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+11 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+12 
	MOVLW       4
	ADDWF       FARG_PrintMacAddr_address+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_PrintMacAddr_address+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+13 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+14 
	MOVLW       5
	ADDWF       FARG_PrintMacAddr_address+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_PrintMacAddr_address+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+15 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+16 
	CALL        _sprintf+0, 0
;PIC_Client.c,88 :: 		return buffer;
	MOVLW       PrintMacAddr_buffer_L0+0
	MOVWF       R0 
	MOVLW       hi_addr(PrintMacAddr_buffer_L0+0)
	MOVWF       R1 
;PIC_Client.c,89 :: 		}
L_end_PrintMacAddr:
	RETURN      0
; end of _PrintMacAddr

_PrintTcpPacket:

;PIC_Client.c,91 :: 		void PrintTcpPacket(PTcpStruct TcpData)
;PIC_Client.c,95 :: 		sprintf(buffer, "\n\rSource IP: %s", PrintIpAddr(TcpData->ip.ScrAddr));
	MOVLW       14
	ADDWF       FARG_PrintTcpPacket_TcpData+0, 0 
	MOVWF       FARG_PrintIpAddr_address+0 
	MOVLW       0
	ADDWFC      FARG_PrintTcpPacket_TcpData+1, 0 
	MOVWF       FARG_PrintIpAddr_address+1 
	MOVLW       12
	ADDWF       FARG_PrintIpAddr_address+0, 1 
	MOVLW       0
	ADDWFC      FARG_PrintIpAddr_address+1, 1 
	CALL        _PrintIpAddr+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        R1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVLW       PrintTcpPacket_buffer_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(PrintTcpPacket_buffer_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_7_PIC_Client+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_7_PIC_Client+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_7_PIC_Client+0)
	MOVWF       FARG_sprintf_f+2 
	CALL        _sprintf+0, 0
;PIC_Client.c,96 :: 		UART1_Write_Text(buffer);
	MOVLW       PrintTcpPacket_buffer_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(PrintTcpPacket_buffer_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,98 :: 		sprintf(buffer, "\n\rDest IP: %s", PrintIpAddr(TcpData->ip.DestAddr));
	MOVLW       14
	ADDWF       FARG_PrintTcpPacket_TcpData+0, 0 
	MOVWF       FARG_PrintIpAddr_address+0 
	MOVLW       0
	ADDWFC      FARG_PrintTcpPacket_TcpData+1, 0 
	MOVWF       FARG_PrintIpAddr_address+1 
	MOVLW       16
	ADDWF       FARG_PrintIpAddr_address+0, 1 
	MOVLW       0
	ADDWFC      FARG_PrintIpAddr_address+1, 1 
	CALL        _PrintIpAddr+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        R1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVLW       PrintTcpPacket_buffer_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(PrintTcpPacket_buffer_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_8_PIC_Client+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_8_PIC_Client+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_8_PIC_Client+0)
	MOVWF       FARG_sprintf_f+2 
	CALL        _sprintf+0, 0
;PIC_Client.c,99 :: 		UART1_Write_Text(buffer);
	MOVLW       PrintTcpPacket_buffer_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(PrintTcpPacket_buffer_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,101 :: 		sprintf(buffer, "\n\rSource Mac: %s", PrintMacAddr(TcpData->eth.ScrMac));
	MOVLW       6
	ADDWF       FARG_PrintTcpPacket_TcpData+0, 0 
	MOVWF       FARG_PrintMacAddr_address+0 
	MOVLW       0
	ADDWFC      FARG_PrintTcpPacket_TcpData+1, 0 
	MOVWF       FARG_PrintMacAddr_address+1 
	CALL        _PrintMacAddr+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        R1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVLW       PrintTcpPacket_buffer_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(PrintTcpPacket_buffer_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_9_PIC_Client+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_9_PIC_Client+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_9_PIC_Client+0)
	MOVWF       FARG_sprintf_f+2 
	CALL        _sprintf+0, 0
;PIC_Client.c,102 :: 		UART1_Write_Text(buffer);
	MOVLW       PrintTcpPacket_buffer_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(PrintTcpPacket_buffer_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,104 :: 		sprintf(buffer, "\n\rDest Mac: %s", PrintMacAddr(TcpData->eth.DestMac));
	MOVF        FARG_PrintTcpPacket_TcpData+0, 0 
	MOVWF       FARG_PrintMacAddr_address+0 
	MOVF        FARG_PrintTcpPacket_TcpData+1, 0 
	MOVWF       FARG_PrintMacAddr_address+1 
	CALL        _PrintMacAddr+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        R1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVLW       PrintTcpPacket_buffer_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(PrintTcpPacket_buffer_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_10_PIC_Client+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_10_PIC_Client+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_10_PIC_Client+0)
	MOVWF       FARG_sprintf_f+2 
	CALL        _sprintf+0, 0
;PIC_Client.c,105 :: 		UART1_Write_Text(buffer);
	MOVLW       PrintTcpPacket_buffer_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(PrintTcpPacket_buffer_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,106 :: 		}
L_end_PrintTcpPacket:
	RETURN      0
; end of _PrintTcpPacket

_SendMessage:

;PIC_Client.c,108 :: 		void SendMessage(PTcpStruct TcpData) {
;PIC_Client.c,112 :: 		IntToShort.IntVal = adc_rd;
	MOVF        _adc_rd+0, 0 
	MOVWF       _IntToShort+0 
	MOVF        _adc_rd+1, 0 
	MOVWF       _IntToShort+1 
;PIC_Client.c,114 :: 		TcpData->tcp.Flags.byte = 0;
	MOVLW       34
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       13
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,116 :: 		UART1_Write_Text("\n\rProto is PSHACK");
	MOVLW       ?lstr11_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr11_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,119 :: 		TcpData->uddata[0] = IntToShort.ShortVal[0];
	MOVLW       54
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       FSR1H 
	MOVF        _IntToShort+0, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,120 :: 		TcpData->uddata[1] = IntToShort.ShortVal[1];
	MOVLW       54
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _IntToShort+1, 0 
	MOVWF       POSTINC1+0 
;PIC_Client.c,121 :: 		TcpData->uddata[2] = 0x00;
	MOVLW       54
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,122 :: 		TxtLen = 2;
	MOVLW       2
	MOVWF       SendMessage_TxtLen_L0+0 
	MOVLW       0
	MOVWF       SendMessage_TxtLen_L0+1 
;PIC_Client.c,124 :: 		TcpData->tcp.SeqNumber = SwapByteOrder(seqNumber);
	MOVLW       34
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FLOC__SendMessage+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__SendMessage+1 
	MOVF        _seqNumber+0, 0 
	MOVWF       FARG_swapByteOrder_ui+0 
	MOVF        _seqNumber+1, 0 
	MOVWF       FARG_swapByteOrder_ui+1 
	MOVF        _seqNumber+2, 0 
	MOVWF       FARG_swapByteOrder_ui+2 
	MOVF        _seqNumber+3, 0 
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
;PIC_Client.c,125 :: 		TcpData->tcp.AckNumber = SwapByteOrder(ackNumber);
	MOVLW       34
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       8
	ADDWF       R0, 0 
	MOVWF       FLOC__SendMessage+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__SendMessage+1 
	MOVF        _ackNumber+0, 0 
	MOVWF       FARG_swapByteOrder_ui+0 
	MOVF        _ackNumber+1, 0 
	MOVWF       FARG_swapByteOrder_ui+1 
	MOVF        _ackNumber+2, 0 
	MOVWF       FARG_swapByteOrder_ui+2 
	MOVF        _ackNumber+3, 0 
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
;PIC_Client.c,126 :: 		TcpData->tcp.Flags.bits.flagPSH = 1;
	MOVLW       34
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       13
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 3 
;PIC_Client.c,127 :: 		TcpData->tcp.Flags.bits.flagACK = 1;
	MOVLW       34
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       13
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 4 
;PIC_Client.c,129 :: 		TcpData->tcp.Window = 0x0004; // 1024
	MOVLW       34
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       14
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       4
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
;PIC_Client.c,130 :: 		TcpData->tcp.DataOffset.Reserved3 = 0x00;
	MOVLW       34
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
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
;PIC_Client.c,131 :: 		TcpData->tcp.DataOffset.Val = 0x05;
	MOVLW       34
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
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
;PIC_Client.c,133 :: 		TcpLen = sizeof(TcpHdr) + TxtLen;
	MOVLW       20
	ADDWF       SendMessage_TxtLen_L0+0, 0 
	MOVWF       _TCPLen+0 
	MOVLW       0
	ADDWFC      SendMessage_TxtLen_L0+1, 0 
	MOVWF       _TCPLen+1 
;PIC_Client.c,135 :: 		TcpData->tcp.Checksum = 0;
	MOVLW       34
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       16
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;PIC_Client.c,136 :: 		TcpData->tcp.UrgentPointer = 0x00;
	MOVLW       34
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       18
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;PIC_Client.c,138 :: 		TcpData->tcp.SourcePort = 0x8D13;
	MOVLW       34
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       FSR1H 
	MOVLW       19
	MOVWF       POSTINC1+0 
	MOVLW       141
	MOVWF       POSTINC1+0 
;PIC_Client.c,139 :: 		TcpData->tcp.DestPort = destinationPort;
	MOVLW       34
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
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
;PIC_Client.c,141 :: 		IpTotLen = sizeof(IpHdr) + TcpLen;
	MOVLW       20
	ADDWF       _TCPLen+0, 0 
	MOVWF       SendMessage_IpTotLen_L0+0 
	MOVLW       0
	ADDWFC      _TCPLen+1, 0 
	MOVWF       SendMessage_IpTotLen_L0+1 
;PIC_Client.c,143 :: 		TcpData->ip.Proto = PROTO_TCP;
	MOVLW       14
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       9
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       6
	MOVWF       POSTINC1+0 
;PIC_Client.c,144 :: 		TcpData->ip.Ver_Len = 0x45;
	MOVLW       14
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       FSR1H 
	MOVLW       69
	MOVWF       POSTINC1+0 
;PIC_Client.c,145 :: 		TcpData->ip.Tos = 0x00;
	MOVLW       14
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,146 :: 		TcpData->ip.PktLen = _SWAP(IpTotLen);
	MOVLW       14
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        SendMessage_IpTotLen_L0+1, 0 
	MOVWF       R3 
	CLRF        R4 
	MOVF        SendMessage_IpTotLen_L0+0, 0 
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
;PIC_Client.c,147 :: 		TcpData->ip.Id = 0x287;
	MOVLW       14
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
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
;PIC_Client.c,148 :: 		TcpData->ip.Offset = 0x0000;
	MOVLW       14
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       6
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;PIC_Client.c,149 :: 		TcpData->ip.Ttl = 128;
	MOVLW       14
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       R1 
	MOVLW       8
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       128
	MOVWF       POSTINC1+0 
;PIC_Client.c,151 :: 		TcpData->eth.Type = 0x0008;
	MOVLW       12
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
	MOVWF       FSR1H 
	MOVLW       8
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
;PIC_Client.c,154 :: 		memcpy(TcpData->ip.ScrAddr, destinationIp, 4);
	MOVLW       14
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       FARG_memcpy_d1+0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
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
;PIC_Client.c,155 :: 		memcpy(TcpData->ip.DestAddr, MyIpAddr, 4);
	MOVLW       14
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       FARG_memcpy_d1+0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
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
;PIC_Client.c,157 :: 		memcpy(TcpData->eth.DestMac, MyMacAddr, 6);
	MOVF        FARG_SendMessage_TcpData+0, 0 
	MOVWF       FARG_memcpy_d1+0 
	MOVF        FARG_SendMessage_TcpData+1, 0 
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
;PIC_Client.c,158 :: 		memcpy(TcpData->eth.ScrMac, destinationMac, 6);
	MOVLW       6
	ADDWF       FARG_SendMessage_TcpData+0, 0 
	MOVWF       FARG_memcpy_d1+0 
	MOVLW       0
	ADDWFC      FARG_SendMessage_TcpData+1, 0 
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
;PIC_Client.c,160 :: 		PseudoData = (PPseudoStruct) PseudoPacket;
	MOVLW       _PseudoPacket+0
	MOVWF       _PseudoData+0 
	MOVLW       hi_addr(_PseudoPacket+0)
	MOVWF       _PseudoData+1 
;PIC_Client.c,162 :: 		Tcp_CheckSum((PPseudoStruct) PseudoData, (PTcpStruct) TcpData);
	MOVF        _PseudoData+0, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpPseudoData+0 
	MOVF        _PseudoData+1, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpPseudoData+1 
	MOVF        FARG_SendMessage_TcpData+0, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpData+0 
	MOVF        FARG_SendMessage_TcpData+1, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpData+1 
	CALL        _Tcp_CheckSum+0, 0
;PIC_Client.c,164 :: 		PrintTcpPacket(TcpData);
	MOVF        FARG_SendMessage_TcpData+0, 0 
	MOVWF       FARG_PrintTcpPacket_TcpData+0 
	MOVF        FARG_SendMessage_TcpData+1, 0 
	MOVWF       FARG_PrintTcpPacket_TcpData+1 
	CALL        _PrintTcpPacket+0, 0
;PIC_Client.c,166 :: 		Trans_TCP ((PTcpStruct) TcpData, PckLen, TCPLen);
	MOVF        FARG_SendMessage_TcpData+0, 0 
	MOVWF       FARG_Trans_TCP_TcpData+0 
	MOVF        FARG_SendMessage_TcpData+1, 0 
	MOVWF       FARG_Trans_TCP_TcpData+1 
	MOVF        _PckLen+0, 0 
	MOVWF       FARG_Trans_TCP_PckLen+0 
	MOVF        _TCPLen+0, 0 
	MOVWF       FARG_Trans_TCP_TCPLen+0 
	MOVF        _TCPLen+1, 0 
	MOVWF       FARG_Trans_TCP_TCPLen+1 
	CALL        _Trans_TCP+0, 0
;PIC_Client.c,167 :: 		}
L_end_SendMessage:
	RETURN      0
; end of _SendMessage

_HandleArpPackage:

;PIC_Client.c,169 :: 		bool HandleArpPackage(PArpStruct arpData) {
;PIC_Client.c,170 :: 		UART1_Write_Text("\n\rARP Pakke. ");
	MOVLW       ?lstr12_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr12_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,171 :: 		if (arpData->arp.HwType == 0x0100 && // HwType = 0001
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
;PIC_Client.c,172 :: 		arpData->arp.PrType == 0x0008 && // PrType = 0x0800
	MOVF        R2, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__HandleArpPackage295
	MOVLW       0
	XORWF       R1, 0 
L__HandleArpPackage295:
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
	GOTO        L__HandleArpPackage296
	MOVLW       8
	XORWF       R1, 0 
L__HandleArpPackage296:
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleArpPackage24
;PIC_Client.c,173 :: 		arpData->arp.HwLen == 0x06 && arpData->arp.PrLen == 0x04 &&
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
;PIC_Client.c,174 :: 		arpData->arp.OpCode == 0x0100 &&
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
	GOTO        L__HandleArpPackage297
	MOVLW       0
	XORWF       R1, 0 
L__HandleArpPackage297:
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleArpPackage24
;PIC_Client.c,175 :: 		IsThisDevice(arpData->arp.TIpAddr)) {
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
;PIC_Client.c,176 :: 		Arp((PArpStruct) arpData, PckLen);
	MOVF        FARG_HandleArpPackage_arpData+0, 0 
	MOVWF       FARG_Arp_PArpData+0 
	MOVF        FARG_HandleArpPackage_arpData+1, 0 
	MOVWF       FARG_Arp_PArpData+1 
	MOVF        _PckLen+0, 0 
	MOVWF       FARG_Arp_PckLen+0 
	CALL        _Arp+0, 0
;PIC_Client.c,177 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_HandleArpPackage
;PIC_Client.c,178 :: 		}
L_HandleArpPackage24:
;PIC_Client.c,180 :: 		return false;
	CLRF        R0 
;PIC_Client.c,182 :: 		}
L_end_HandleArpPackage:
	RETURN      0
; end of _HandleArpPackage

_HandleUdpPackage:

;PIC_Client.c,184 :: 		void HandleUdpPackage(PUdpStruct udpData)
;PIC_Client.c,187 :: 		UART1_Write_Text("UDP Pakke!!!\n\r");
	MOVLW       ?lstr13_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr13_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,188 :: 		if (Udp_Rec((PUdpStruct) UdpData, PckLen)) {
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
;PIC_Client.c,189 :: 		pseudoData = (PPseudoStruct) PseudoPacket;
	MOVLW       _PseudoPacket+0
	MOVWF       HandleUdpPackage_pseudoData_L0+0 
	MOVLW       hi_addr(_PseudoPacket+0)
	MOVWF       HandleUdpPackage_pseudoData_L0+1 
;PIC_Client.c,190 :: 		udp_CheckSum(pseudoData, (PUdpStruct) UdpData);
	MOVF        HandleUdpPackage_pseudoData_L0+0, 0 
	MOVWF       FARG_Udp_CheckSum_UdpPseudoData+0 
	MOVF        HandleUdpPackage_pseudoData_L0+1, 0 
	MOVWF       FARG_Udp_CheckSum_UdpPseudoData+1 
	MOVF        FARG_HandleUdpPackage_udpData+0, 0 
	MOVWF       FARG_Udp_CheckSum_UdpData+0 
	MOVF        FARG_HandleUdpPackage_udpData+1, 0 
	MOVWF       FARG_Udp_CheckSum_UdpData+1 
	CALL        _Udp_CheckSum+0, 0
;PIC_Client.c,191 :: 		Udp_Trans((PUdpStruct) UdpData, PckLen);
	MOVF        FARG_HandleUdpPackage_udpData+0, 0 
	MOVWF       FARG_Udp_Trans_PUdpData+0 
	MOVF        FARG_HandleUdpPackage_udpData+1, 0 
	MOVWF       FARG_Udp_Trans_PUdpData+1 
	MOVF        _PckLen+0, 0 
	MOVWF       FARG_Udp_Trans_PckLen+0 
	CALL        _Udp_Trans+0, 0
;PIC_Client.c,192 :: 		}
L_HandleUdpPackage26:
;PIC_Client.c,193 :: 		}
L_end_HandleUdpPackage:
	RETURN      0
; end of _HandleUdpPackage

_HandleTcpPackage:

;PIC_Client.c,195 :: 		void HandleTcpPackage(PTcpStruct tcpData)
;PIC_Client.c,200 :: 		UART1_Write_Text("TCP Pakke modtaget\n\r");
	MOVLW       ?lstr14_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr14_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,201 :: 		if (tcpData->tcp.DestPort == 0x8D13) //Port TCP port 5005 0x138D
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
	GOTO        L__HandleTcpPackage300
	MOVLW       19
	XORWF       R1, 0 
L__HandleTcpPackage300:
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleTcpPackage27
;PIC_Client.c,203 :: 		UART1_Write_Text("TCP Pakke modtaget port 5005\n\r");
	MOVLW       ?lstr15_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr15_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,205 :: 		tcpData = (PTcpStruct) Packet;
	MOVLW       _Packet+0
	MOVWF       FARG_HandleTcpPackage_tcpData+0 
	MOVLW       hi_addr(_Packet+0)
	MOVWF       FARG_HandleTcpPackage_tcpData+1 
;PIC_Client.c,207 :: 		seqNumber = SwapByteOrder(tcpData->tcp.AckNumber);
	MOVLW       34
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       R1 
	MOVLW       8
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_swapByteOrder_ui+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_swapByteOrder_ui+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_swapByteOrder_ui+2 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_swapByteOrder_ui+3 
	CALL        _swapByteOrder+0, 0
	MOVF        R0, 0 
	MOVWF       _seqNumber+0 
	MOVF        R1, 0 
	MOVWF       _seqNumber+1 
	MOVF        R2, 0 
	MOVWF       _seqNumber+2 
	MOVF        R3, 0 
	MOVWF       _seqNumber+3 
;PIC_Client.c,208 :: 		ackNumber = SwapByteOrder(tcpData->tcp.SeqNumber);
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
	MOVWF       FARG_swapByteOrder_ui+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_swapByteOrder_ui+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_swapByteOrder_ui+2 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_swapByteOrder_ui+3 
	CALL        _swapByteOrder+0, 0
	MOVF        R0, 0 
	MOVWF       _ackNumber+0 
	MOVF        R1, 0 
	MOVWF       _ackNumber+1 
	MOVF        R2, 0 
	MOVWF       _ackNumber+2 
	MOVF        R3, 0 
	MOVWF       _ackNumber+3 
;PIC_Client.c,210 :: 		pseudoData = (PPseudoStruct) PseudoPacket;
	MOVLW       _PseudoPacket+0
	MOVWF       HandleTcpPackage_pseudoData_L0+0 
	MOVLW       hi_addr(_PseudoPacket+0)
	MOVWF       HandleTcpPackage_pseudoData_L0+1 
;PIC_Client.c,211 :: 		Tcp_CheckSum((PPseudoStruct) pseudoData, (PTcpStruct) tcpData);
	MOVF        HandleTcpPackage_pseudoData_L0+0, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpPseudoData+0 
	MOVF        HandleTcpPackage_pseudoData_L0+1, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpPseudoData+1 
	MOVF        FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpData+0 
	MOVF        FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpData+1 
	CALL        _Tcp_CheckSum+0, 0
;PIC_Client.c,213 :: 		TCPFlags.byte = tcpData->tcp.Flags.byte;
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
;PIC_Client.c,214 :: 		tcpData->tcp.Flags.byte = 0;
	MOVFF       R2, FSR1
	MOVFF       R3, FSR1H
	CLRF        POSTINC1+0 
;PIC_Client.c,216 :: 		if (TCPFlags.byte == SYN) {
	MOVF        _TCPFlags+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleTcpPackage28
;PIC_Client.c,217 :: 		UART1_Write_Text("TCP SYN Pakke modtaget\n\r");
	MOVLW       ?lstr16_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr16_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,218 :: 		TCP_Ack_Num = tcpData->tcp.SeqNumber;
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
;PIC_Client.c,219 :: 		TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
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
;PIC_Client.c,220 :: 		TCP_Ack_Num++;
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
;PIC_Client.c,221 :: 		TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
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
;PIC_Client.c,222 :: 		tcpData->tcp.AckNumber = TCP_Ack_Num;
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
;PIC_Client.c,224 :: 		tcpData->tcp.SeqNumber = 0x78563412; //0x12345678
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
;PIC_Client.c,226 :: 		tcpData->tcp.Flags.bits.flagSYN = 1;
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
;PIC_Client.c,227 :: 		tcpData->tcp.Flags.bits.flagACK = 1;
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
;PIC_Client.c,229 :: 		TCPLen = tcpData->tcp.DataOffset.Val * 4;
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
;PIC_Client.c,230 :: 		Trans_TCP((PTcpStruct) tcpData, PckLen, TCPLen);
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
;PIC_Client.c,232 :: 		UART1_Write_Text("TCP SYN Pakke sendt\n\r");
	MOVLW       ?lstr17_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr17_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,233 :: 		} else if (TCPFlags.byte == PSHACK) {
	GOTO        L_HandleTcpPackage29
L_HandleTcpPackage28:
	MOVF        _TCPFlags+0, 0 
	XORLW       24
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleTcpPackage30
;PIC_Client.c,236 :: 		UART1_Write_Text("TCP ACK DataPakke modtaget\n\r");
	MOVLW       ?lstr18_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr18_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,238 :: 		DataLen = _SWAP((tcpData->ip.PktLen));
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
;PIC_Client.c,239 :: 		TCPDataLen = DataLen - ((tcpData->tcp.DataOffset.Val * 4) + 20);
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
;PIC_Client.c,240 :: 		if (TCPDataLen) {
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_HandleTcpPackage31
;PIC_Client.c,241 :: 		TCP_Ack_Num = tcpData->tcp.SeqNumber;
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
;PIC_Client.c,242 :: 		TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
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
;PIC_Client.c,243 :: 		TCP_Ack_Num += TCPDataLen;
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
;PIC_Client.c,244 :: 		TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
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
;PIC_Client.c,246 :: 		sprintf(buffer, "%d", seqNumber);
	MOVLW       HandleTcpPackage_buffer_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(HandleTcpPackage_buffer_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_19_PIC_Client+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_19_PIC_Client+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_19_PIC_Client+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        _seqNumber+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _seqNumber+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        _seqNumber+2, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVF        _seqNumber+3, 0 
	MOVWF       FARG_sprintf_wh+8 
	CALL        _sprintf+0, 0
;PIC_Client.c,247 :: 		UART1_Write_Text("\n\rAfter: ");
	MOVLW       ?lstr20_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr20_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,248 :: 		UART1_Write_Text(buffer);
	MOVLW       HandleTcpPackage_buffer_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(HandleTcpPackage_buffer_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,249 :: 		UART1_Write_Text("\n\r");
	MOVLW       ?lstr21_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr21_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,251 :: 		tcpData->tcp.SeqNumber = tcpData->tcp.AckNumber;
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
;PIC_Client.c,252 :: 		tcpData->tcp.AckNumber = TCP_Ack_Num;
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
;PIC_Client.c,254 :: 		tcpData->tcp.Flags.bits.flagACK = 1;
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
;PIC_Client.c,256 :: 		UART1_Write_Text("\n\r");
	MOVLW       ?lstr22_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr22_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,258 :: 		UART1_Write_Text(tcpData->uddata);
	MOVLW       54
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,259 :: 		UART1_Write_Text("\n\r");
	MOVLW       ?lstr23_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr23_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,261 :: 		for (i = 0; i <= TCPDataLen; i++) {
	CLRF        HandleTcpPackage_i_L2+0 
L_HandleTcpPackage32:
	MOVLW       0
	SUBWF       _TCPDataLen+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__HandleTcpPackage301
	MOVF        HandleTcpPackage_i_L2+0, 0 
	SUBWF       _TCPDataLen+0, 0 
L__HandleTcpPackage301:
	BTFSS       STATUS+0, 0 
	GOTO        L_HandleTcpPackage33
;PIC_Client.c,262 :: 		if (tcpData->uddata[i] > 'a' && tcpData->uddata[i] < 'z')
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
;PIC_Client.c,263 :: 		tcpData->uddata[i].B5 = 0;
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
;PIC_Client.c,261 :: 		for (i = 0; i <= TCPDataLen; i++) {
	INCF        HandleTcpPackage_i_L2+0, 1 
;PIC_Client.c,264 :: 		}
	GOTO        L_HandleTcpPackage32
L_HandleTcpPackage33:
;PIC_Client.c,265 :: 		tcpData->uddata[TCPDataLen] = 0;
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
;PIC_Client.c,267 :: 		UART1_Write_Text(tcpData->uddata);
	MOVLW       54
	ADDWF       FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       0
	ADDWFC      FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,269 :: 		TCPLen = tcpData->tcp.DataOffset.Val * 4;
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
;PIC_Client.c,271 :: 		pseudoData = (PPseudoStruct) PseudoPacket;
	MOVLW       _PseudoPacket+0
	MOVWF       HandleTcpPackage_pseudoData_L0+0 
	MOVLW       hi_addr(_PseudoPacket+0)
	MOVWF       HandleTcpPackage_pseudoData_L0+1 
;PIC_Client.c,272 :: 		Tcp_CheckSum((PPseudoStruct) pseudoData, (PTcpStruct) tcpData);
	MOVF        HandleTcpPackage_pseudoData_L0+0, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpPseudoData+0 
	MOVF        HandleTcpPackage_pseudoData_L0+1, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpPseudoData+1 
	MOVF        FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpData+0 
	MOVF        FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FARG_Tcp_CheckSum_TcpData+1 
	CALL        _Tcp_CheckSum+0, 0
;PIC_Client.c,273 :: 		Trans_TCP((PTcpStruct) tcpData, PckLen, (TCPLen + TcpDataLen));
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
;PIC_Client.c,275 :: 		UART1_Write_Text("\n\rTCP ACK Pakke sendt\n\r");
	MOVLW       ?lstr24_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr24_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,276 :: 		}
L_HandleTcpPackage31:
;PIC_Client.c,278 :: 		UART1_Write_Text("\n\rGemmer data");
	MOVLW       ?lstr25_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr25_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,279 :: 		destinationPort = tcpData->tcp.DestPort;
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
	MOVWF       _destinationPort+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       _destinationPort+1 
;PIC_Client.c,280 :: 		memcpy(destinationMac, tcpData->eth.DestMac, 6);
	MOVLW       _destinationMac+0
	MOVWF       FARG_memcpy_d1+0 
	MOVLW       hi_addr(_destinationMac+0)
	MOVWF       FARG_memcpy_d1+1 
	MOVF        FARG_HandleTcpPackage_tcpData+0, 0 
	MOVWF       FARG_memcpy_s1+0 
	MOVF        FARG_HandleTcpPackage_tcpData+1, 0 
	MOVWF       FARG_memcpy_s1+1 
	MOVLW       6
	MOVWF       FARG_memcpy_n+0 
	MOVLW       0
	MOVWF       FARG_memcpy_n+1 
	CALL        _memcpy+0, 0
;PIC_Client.c,281 :: 		memcpy(destinationIp, tcpData->ip.DestAddr, 4);
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
	MOVLW       16
	ADDWF       FARG_memcpy_s1+0, 1 
	MOVLW       0
	ADDWFC      FARG_memcpy_s1+1, 1 
	MOVLW       4
	MOVWF       FARG_memcpy_n+0 
	MOVLW       0
	MOVWF       FARG_memcpy_n+1 
	CALL        _memcpy+0, 0
;PIC_Client.c,283 :: 		sprintf(buffer, "\n\rDestination IP variable: %s", PrintIpAddr(destinationIp));
	MOVLW       _destinationIp+0
	MOVWF       FARG_PrintIpAddr_address+0 
	MOVLW       hi_addr(_destinationIp+0)
	MOVWF       FARG_PrintIpAddr_address+1 
	CALL        _PrintIpAddr+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        R1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVLW       HandleTcpPackage_buffer_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(HandleTcpPackage_buffer_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_26_PIC_Client+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_26_PIC_Client+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_26_PIC_Client+0)
	MOVWF       FARG_sprintf_f+2 
	CALL        _sprintf+0, 0
;PIC_Client.c,284 :: 		UART1_Write_Text(buffer);
	MOVLW       HandleTcpPackage_buffer_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(HandleTcpPackage_buffer_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,285 :: 		sprintf(buffer, "\n\rDestination Mac variable: %s", PrintMacAddr(destinationMac));
	MOVLW       _destinationMac+0
	MOVWF       FARG_PrintMacAddr_address+0 
	MOVLW       hi_addr(_destinationMac+0)
	MOVWF       FARG_PrintMacAddr_address+1 
	CALL        _PrintMacAddr+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        R1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVLW       HandleTcpPackage_buffer_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(HandleTcpPackage_buffer_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_27_PIC_Client+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_27_PIC_Client+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_27_PIC_Client+0)
	MOVWF       FARG_sprintf_f+2 
	CALL        _sprintf+0, 0
;PIC_Client.c,286 :: 		UART1_Write_Text(buffer);
	MOVLW       HandleTcpPackage_buffer_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(HandleTcpPackage_buffer_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,288 :: 		} else if (TCPFlags.byte == FINACK) {
	GOTO        L_HandleTcpPackage38
L_HandleTcpPackage30:
	MOVF        _TCPFlags+0, 0 
	XORLW       17
	BTFSS       STATUS+0, 2 
	GOTO        L_HandleTcpPackage39
;PIC_Client.c,289 :: 		UART1_Write_Text("TCP FIN ACK Pakke modtaget\n\r");
	MOVLW       ?lstr28_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr28_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,290 :: 		TCP_Ack_Num = tcpData->tcp.SeqNumber;
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
;PIC_Client.c,291 :: 		TCP_Ack_Num = SwapByteOrder(TCP_Ack_Num);
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
;PIC_Client.c,292 :: 		TCP_Ack_Num++;
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
;PIC_Client.c,293 :: 		TCP_Ack_num = SwapByteOrder(TCP_Ack_Num);
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
;PIC_Client.c,295 :: 		tcpData->tcp.SeqNumber = tcpData->tcp.AckNumber;
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
;PIC_Client.c,296 :: 		tcpData->tcp.AckNumber = TCP_Ack_Num;
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
;PIC_Client.c,298 :: 		tcpData->tcp.Flags.bits.flagACK = 1;
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
;PIC_Client.c,299 :: 		tcpData->tcp.Flags.bits.flagFIN = 1;
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
;PIC_Client.c,301 :: 		TCPLen = tcpData->tcp.DataOffset.Val * 4;
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
;PIC_Client.c,302 :: 		Trans_TCP((PTcpStruct) tcpData, PckLen, TCPLen);
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
;PIC_Client.c,303 :: 		UART1_Write_Text("TCP ACK - FIN Pakke sendt\n\r");
	MOVLW       ?lstr29_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr29_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,304 :: 		}
L_HandleTcpPackage39:
L_HandleTcpPackage38:
L_HandleTcpPackage29:
;PIC_Client.c,305 :: 		}
L_HandleTcpPackage27:
;PIC_Client.c,306 :: 		}
L_end_HandleTcpPackage:
	RETURN      0
; end of _HandleTcpPackage

_IsThisDevice:

;PIC_Client.c,308 :: 		bool IsThisDevice(unsigned short ipAddr[])
;PIC_Client.c,311 :: 		ipAddr[1] == MyIpAddr[1] &&
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
;PIC_Client.c,312 :: 		ipAddr[2] == MyIpAddr[2] &&
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
;PIC_Client.c,313 :: 		ipAddr[3] == MyIpAddr[3])
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
;PIC_Client.c,315 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_IsThisDevice
;PIC_Client.c,316 :: 		}
L_IsThisDevice42:
;PIC_Client.c,319 :: 		return false;
	CLRF        R0 
;PIC_Client.c,321 :: 		}
L_end_IsThisDevice:
	RETURN      0
; end of _IsThisDevice

_Tcp_CheckSum:

;PIC_Client.c,323 :: 		unsigned int Tcp_CheckSum(PPseudoStruct TcpPseudoData, PTcpStruct TcpData) {
;PIC_Client.c,329 :: 		DataLen = _SWAP(TcpData->ip.PktLen);
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
;PIC_Client.c,330 :: 		TCPDataLen = DataLen - ((TcpData->tcp.DataOffset.Val * 4) + 20);
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
;PIC_Client.c,332 :: 		TcpHdrLen = (TcpData->tcp.DataOffset.Val * 4) + TCPDataLen;
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
;PIC_Client.c,334 :: 		for (i = 0; i <= 3; i++) {
	CLRF        Tcp_CheckSum_i_L0+0 
L_Tcp_CheckSum44:
	MOVF        Tcp_CheckSum_i_L0+0, 0 
	SUBLW       3
	BTFSS       STATUS+0, 0 
	GOTO        L_Tcp_CheckSum45
;PIC_Client.c,335 :: 		TcpPseudoData->SrcIP[i] = TcpData->ip.ScrAddr[i];
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
;PIC_Client.c,336 :: 		TcpPseudoData->DestIP[i] = TcpData->ip.DestAddr[i];
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
;PIC_Client.c,334 :: 		for (i = 0; i <= 3; i++) {
	INCF        Tcp_CheckSum_i_L0+0, 1 
;PIC_Client.c,337 :: 		}
	GOTO        L_Tcp_CheckSum44
L_Tcp_CheckSum45:
;PIC_Client.c,338 :: 		TcpPseudoData->Zero = 0;
	MOVLW       8
	ADDWF       FARG_Tcp_CheckSum_TcpPseudoData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Tcp_CheckSum_TcpPseudoData+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,339 :: 		TcpPseudoData->Proto = PROTO_TCP; //TCP
	MOVLW       9
	ADDWF       FARG_Tcp_CheckSum_TcpPseudoData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Tcp_CheckSum_TcpPseudoData+1, 0 
	MOVWF       FSR1H 
	MOVLW       6
	MOVWF       POSTINC1+0 
;PIC_Client.c,340 :: 		TcpPseudoData->DataLen = _SWAP(TcpHdrLen);
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
;PIC_Client.c,342 :: 		UdPacket((unsigned short * ) TcpPseudoData, 12);
	MOVF        FARG_Tcp_CheckSum_TcpPseudoData+0, 0 
	MOVWF       FARG_UdPacket_Data+0 
	MOVF        FARG_Tcp_CheckSum_TcpPseudoData+1, 0 
	MOVWF       FARG_UdPacket_Data+1 
	MOVLW       12
	MOVWF       FARG_UdPacket_len+0 
	MOVLW       0
	MOVWF       FARG_UdPacket_len+1 
	CALL        _UdPacket+0, 0
;PIC_Client.c,343 :: 		UART1_Write_Text("TCP pseudo Trans Pakke\n\r");
	MOVLW       ?lstr30_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr30_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,345 :: 		TcpCkSum = Cksum(UDASTART, 12, 0); //Tcp Pseudo checksum seed = 0
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
;PIC_Client.c,348 :: 		return TcpCkSum;
;PIC_Client.c,349 :: 		}
L_end_Tcp_CheckSum:
	RETURN      0
; end of _Tcp_CheckSum

_Trans_TCP:

;PIC_Client.c,352 :: 		void Trans_TCP(PTcpStruct TcpData, unsigned short PckLen, unsigned TCPLen) {
;PIC_Client.c,355 :: 		SwapAddr((PIpStruct) TcpData);
	MOVF        FARG_Trans_TCP_TcpData+0, 0 
	MOVWF       FARG_SwapAddr_IpData+0 
	MOVF        FARG_Trans_TCP_TcpData+1, 0 
	MOVWF       FARG_SwapAddr_IpData+1 
	CALL        _SwapAddr+0, 0
;PIC_Client.c,357 :: 		temp = TcpData->Tcp.SourcePort; // Swap portNr.
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
;PIC_Client.c,358 :: 		TcpData->tcp.SourcePort = TcpData->tcp.DestPort;
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
;PIC_Client.c,359 :: 		TcpData->tcp.DestPort = temp;
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
;PIC_Client.c,361 :: 		TcpData->tcp.Checksum = 0;
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
;PIC_Client.c,363 :: 		TxPacket((unsigned short * ) TcpData, PckLen, FALSE); //Fill Eth Buffer Don't send
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
;PIC_Client.c,365 :: 		TcpData->tcp.Checksum = CkSum(sizeof(IpStruct), TCPLen, TRUE);; // Checksum with seed
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
;PIC_Client.c,371 :: 		TxPacket((unsigned short * ) TcpData, PckLen, TRUE); //Fill Eth Buffer And send
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
;PIC_Client.c,372 :: 		}
L_end_Trans_TCP:
	RETURN      0
; end of _Trans_TCP

_Udp_Rec:

;PIC_Client.c,374 :: 		unsigned short Udp_Rec(PUdpStruct PUdpData, unsigned short PckLen) {
;PIC_Client.c,376 :: 		UART1_Write_Text("UDP Pakke modtaget\n\r");
	MOVLW       ?lstr31_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr31_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,377 :: 		if (PUdpData->udp.DestPort == 0x8D13) // Port 5005
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
	GOTO        L__Udp_Rec306
	MOVLW       19
	XORWF       R1, 0 
L__Udp_Rec306:
	BTFSS       STATUS+0, 2 
	GOTO        L_Udp_Rec47
;PIC_Client.c,379 :: 		TekstLen = SWAP(PUdpData->udp.Len) - 8; //Tekst længde - UDP Hdr.
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
;PIC_Client.c,380 :: 		PUdpData->uddata[TekstLen] = 0;
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
;PIC_Client.c,381 :: 		UART1_Write_Text(PUdpData->uddata);
	MOVLW       42
	ADDWF       FARG_Udp_Rec_PUdpData+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       0
	ADDWFC      FARG_Udp_Rec_PUdpData+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,382 :: 		UART1_Write_Text("\n\r");
	MOVLW       ?lstr32_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr32_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,383 :: 		UART1_Write_Text("UDP Pakke modtaget port 5005\n\r");
	MOVLW       ?lstr33_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr33_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,384 :: 		return TRUE;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_Udp_Rec
;PIC_Client.c,385 :: 		} else return FALSE;
L_Udp_Rec47:
	CLRF        R0 
;PIC_Client.c,386 :: 		}
L_end_Udp_Rec:
	RETURN      0
; end of _Udp_Rec

_Udp_CheckSum:

;PIC_Client.c,390 :: 		unsigned int Udp_CheckSum(PPseudoStruct UdpPseudoData, PUdpStruct UdpData) {
;PIC_Client.c,394 :: 		for (i = 0; i <= 3; i++) {
	CLRF        Udp_CheckSum_i_L0+0 
L_Udp_CheckSum49:
	MOVF        Udp_CheckSum_i_L0+0, 0 
	SUBLW       3
	BTFSS       STATUS+0, 0 
	GOTO        L_Udp_CheckSum50
;PIC_Client.c,395 :: 		UdpPseudoData->SrcIP[i] = UdpData->ip.ScrAddr[i];
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
;PIC_Client.c,396 :: 		UdpPseudoData->DestIP[i] = UdpData->ip.DestAddr[i];
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
;PIC_Client.c,394 :: 		for (i = 0; i <= 3; i++) {
	INCF        Udp_CheckSum_i_L0+0, 1 
;PIC_Client.c,397 :: 		}
	GOTO        L_Udp_CheckSum49
L_Udp_CheckSum50:
;PIC_Client.c,398 :: 		UdpPseudoData->Zero = 0;
	MOVLW       8
	ADDWF       FARG_Udp_CheckSum_UdpPseudoData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Udp_CheckSum_UdpPseudoData+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,399 :: 		UdpPseudoData->Proto = 17; //UDP
	MOVLW       9
	ADDWF       FARG_Udp_CheckSum_UdpPseudoData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Udp_CheckSum_UdpPseudoData+1, 0 
	MOVWF       FSR1H 
	MOVLW       17
	MOVWF       POSTINC1+0 
;PIC_Client.c,400 :: 		UdpPseudoData->DataLen = UdpData->udp.Len;
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
;PIC_Client.c,401 :: 		UdPacket((unsigned short * ) UdpPseudoData, 12);
	MOVF        FARG_Udp_CheckSum_UdpPseudoData+0, 0 
	MOVWF       FARG_UdPacket_Data+0 
	MOVF        FARG_Udp_CheckSum_UdpPseudoData+1, 0 
	MOVWF       FARG_UdPacket_Data+1 
	MOVLW       12
	MOVWF       FARG_UdPacket_len+0 
	MOVLW       0
	MOVWF       FARG_UdPacket_len+1 
	CALL        _UdPacket+0, 0
;PIC_Client.c,402 :: 		UART1_Write_Text("UDP pseudo Trans Pakke\n\r");
	MOVLW       ?lstr34_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr34_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,404 :: 		CheckSum = Cksum(UDASTART, 12, 0); //Udp Pseudo checksum seed = 0
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
;PIC_Client.c,406 :: 		WordToStr(Checksum, HexStr);
	MOVF        R0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _HexStr+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_HexStr+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;PIC_Client.c,407 :: 		UART1_Write_Text("\n\rPseudo Checksum  :");
	MOVLW       ?lstr35_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr35_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,408 :: 		UART1_Write_Text(HexStr);
	MOVLW       _HexStr+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_HexStr+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,409 :: 		UART1_Write_Text("\n\r");
	MOVLW       ?lstr36_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr36_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,412 :: 		return CheckSum;
	MOVF        Udp_CheckSum_CheckSum_L0+0, 0 
	MOVWF       R0 
	MOVF        Udp_CheckSum_CheckSum_L0+1, 0 
	MOVWF       R1 
;PIC_Client.c,413 :: 		}
L_end_Udp_CheckSum:
	RETURN      0
; end of _Udp_CheckSum

_Udp_Trans:

;PIC_Client.c,416 :: 		void Udp_Trans(PUdpStruct PUdpData, unsigned short PckLen) {
;PIC_Client.c,421 :: 		UART1_Write_Text("UDP Trans Pakke\n\r");
	MOVLW       ?lstr37_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr37_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,422 :: 		UdpLen = _SWAP(PUdpData->udp.Len);
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
;PIC_Client.c,423 :: 		TekstLen = UdpLen - 8; //Tekst længde - UDP Hdr.
	MOVLW       8
	SUBWF       R0, 0 
	MOVWF       Udp_Trans_TekstLen_L0+0 
;PIC_Client.c,424 :: 		SwapAddr((PIpStruct) PUdpData);
	MOVF        FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       FARG_SwapAddr_IpData+0 
	MOVF        FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       FARG_SwapAddr_IpData+1 
	CALL        _SwapAddr+0, 0
;PIC_Client.c,425 :: 		temp = PUdpData->udp.SrcPort;
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
;PIC_Client.c,426 :: 		PUdpData->udp.SrcPort = PUdpData->udp.DestPort;
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
;PIC_Client.c,427 :: 		PUdpData->udp.DestPort = temp;
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
;PIC_Client.c,428 :: 		PUdpData->udp.CkSum = 0;
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
;PIC_Client.c,430 :: 		for (i = 0; i <= TekstLen; i++) {
	CLRF        Udp_Trans_i_L0+0 
L_Udp_Trans52:
	MOVF        Udp_Trans_i_L0+0, 0 
	SUBWF       Udp_Trans_TekstLen_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Udp_Trans53
;PIC_Client.c,431 :: 		if (PUdpData->uddata[i] >= 'a' && PUdpData->uddata[i] <= 'z')
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
;PIC_Client.c,432 :: 		PUdpData->uddata[i].B5 = 0;
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
;PIC_Client.c,430 :: 		for (i = 0; i <= TekstLen; i++) {
	INCF        Udp_Trans_i_L0+0, 1 
;PIC_Client.c,433 :: 		}
	GOTO        L_Udp_Trans52
L_Udp_Trans53:
;PIC_Client.c,434 :: 		PUdpData->uddata[TekstLen] = 0;
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
;PIC_Client.c,436 :: 		TxPacket((unsigned short * ) PUdpData, PckLen, FALSE); //Fill Eth Buffer Don't send
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
;PIC_Client.c,438 :: 		PUdpData->udp.CkSum = Cksum(sizeof(IpStruct), UdpLen, 1); // Checksum with seed
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
;PIC_Client.c,439 :: 		ShowPacket((unsigned short * ) PUdpData, PckLen);
	MOVF        FARG_Udp_Trans_PUdpData+0, 0 
	MOVWF       FARG_ShowPacket_Buffer+0 
	MOVF        FARG_Udp_Trans_PUdpData+1, 0 
	MOVWF       FARG_ShowPacket_Buffer+1 
	MOVF        FARG_Udp_Trans_PckLen+0, 0 
	MOVWF       FARG_ShowPacket_len+0 
	MOVLW       0
	MOVWF       FARG_ShowPacket_len+1 
	CALL        _ShowPacket+0, 0
;PIC_Client.c,440 :: 		TxPacket((unsigned short * ) PUdpData, PckLen, TRUE); //Fill Eth Buffer And send
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
;PIC_Client.c,441 :: 		}
L_end_Udp_Trans:
	RETURN      0
; end of _Udp_Trans

_Icmp:

;PIC_Client.c,443 :: 		void Icmp(PIcmpStruct PIcmpData, unsigned short PckLen) {
;PIC_Client.c,445 :: 		PIcmpData->icmp.Type = 0x00;
	MOVLW       34
	ADDWF       FARG_Icmp_PIcmpData+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Icmp_PIcmpData+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,446 :: 		PIcmpData->icmp.Code = 0x00; //Set Echo Reply
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
;PIC_Client.c,447 :: 		PIcmpData->icmp.CkSum = 0x0000; //Clear ICMP checksum
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
;PIC_Client.c,448 :: 		PIcmpData->ip.CkSum = 0x0000; //Clear IP checksum
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
;PIC_Client.c,449 :: 		SwapAddr((PIpStruct) PIcmpData);
	MOVF        FARG_Icmp_PIcmpData+0, 0 
	MOVWF       FARG_SwapAddr_IpData+0 
	MOVF        FARG_Icmp_PIcmpData+1, 0 
	MOVWF       FARG_SwapAddr_IpData+1 
	CALL        _SwapAddr+0, 0
;PIC_Client.c,450 :: 		TxPacket((unsigned short * ) PIcmpData, PckLen, 0); //Fill Eth Buffer Don't send
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
;PIC_Client.c,452 :: 		PIcmpData->ip.CkSum = CkSum(sizeof(EthHdr), sizeof(IpHdr), 0);
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
;PIC_Client.c,454 :: 		len = SWAP(PIcmpData->ip.PktLen);
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
;PIC_Client.c,455 :: 		PIcmpData->icmp.CkSum = CkSum(sizeof(IpStruct), PckLen - sizeof(IpStruct), 0); //ICMP hdr + Data Payload
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
;PIC_Client.c,456 :: 		TxPacket((unsigned short * ) PIcmpData, PckLen, 1); //Fill Eth Buffer And send
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
;PIC_Client.c,457 :: 		}
L_end_Icmp:
	RETURN      0
; end of _Icmp

_Arp:

;PIC_Client.c,459 :: 		void Arp(PArpStruct PArpData, unsigned short PckLen) {
;PIC_Client.c,463 :: 		PArpData->arp.OpCode = _SWAP(0x0002);
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
;PIC_Client.c,464 :: 		for (i = 0; i <= 5; i++) {
	CLRF        Arp_i_L0+0 
L_Arp58:
	MOVF        Arp_i_L0+0, 0 
	SUBLW       5
	BTFSS       STATUS+0, 0 
	GOTO        L_Arp59
;PIC_Client.c,465 :: 		PArpData->eth.DestMac[i] = PArpData->eth.ScrMac[i];
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
;PIC_Client.c,466 :: 		PArpData->arp.THwAddr[i] = PArpData->arp.SHwAddr[i];
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
;PIC_Client.c,467 :: 		PArpData->eth.ScrMac[i] = MyMacAddr[i];
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
;PIC_Client.c,468 :: 		PArpData->arp.SHwAddr[i] = MyMacAddr[i];
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
;PIC_Client.c,464 :: 		for (i = 0; i <= 5; i++) {
	INCF        Arp_i_L0+0, 1 
;PIC_Client.c,469 :: 		}
	GOTO        L_Arp58
L_Arp59:
;PIC_Client.c,470 :: 		for (i = 0; i <= 3; i++) {
	CLRF        Arp_i_L0+0 
L_Arp61:
	MOVF        Arp_i_L0+0, 0 
	SUBLW       3
	BTFSS       STATUS+0, 0 
	GOTO        L_Arp62
;PIC_Client.c,471 :: 		PArpData->arp.TIpAddr[i] = PArpData->arp.SIpAddr[i];
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
;PIC_Client.c,472 :: 		PArpData->arp.SIpAddr[i] = MyIpAddr[i];
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
;PIC_Client.c,470 :: 		for (i = 0; i <= 3; i++) {
	INCF        Arp_i_L0+0, 1 
;PIC_Client.c,473 :: 		}
	GOTO        L_Arp61
L_Arp62:
;PIC_Client.c,475 :: 		TxPacket((unsigned short * ) PArpData, Len, 1);
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
;PIC_Client.c,476 :: 		}
L_end_Arp:
	RETURN      0
; end of _Arp

_UdPacket:

;PIC_Client.c,478 :: 		void UdPacket(unsigned short * Data, unsigned len) {
;PIC_Client.c,479 :: 		WriteReg(EUDAWRPT, UDASTART);
	MOVLW       144
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       82
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       6
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,480 :: 		WriteReg(EUDARDPT, UDASTART);
	MOVLW       142
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       82
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       6
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,481 :: 		WriteMemoryWindow(UDA_WINDOW, Data, len);
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
;PIC_Client.c,483 :: 		}
L_end_UdPacket:
	RETURN      0
; end of _UdPacket

_TxPacket:

;PIC_Client.c,485 :: 		void TxPacket(unsigned short * PkData, unsigned len, unsigned short TX) {
;PIC_Client.c,487 :: 		do {
L_TxPacket64:
;PIC_Client.c,488 :: 		read = ReadReg(ECON1);
	MOVLW       30
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
;PIC_Client.c,489 :: 		} while (Read & ECON1_TXRTS);
	BTFSC       R0, 1 
	GOTO        L_TxPacket64
;PIC_Client.c,490 :: 		WriteReg(ERXWRPT, TXSTART);
	MOVLW       140
	MOVWF       FARG_WriteReg_wAddress+0 
	CLRF        FARG_WriteReg_wValue+0 
	CLRF        FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,491 :: 		WriteMemoryWindow(RX_WINDOW, PkData, len);
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
;PIC_Client.c,492 :: 		if (TX) {
	MOVF        FARG_TxPacket_TX+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_TxPacket67
;PIC_Client.c,493 :: 		WriteReg(ETXST, (unsigned) 0x0000);
	CLRF        FARG_WriteReg_wAddress+0 
	CLRF        FARG_WriteReg_wValue+0 
	CLRF        FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,494 :: 		WriteReg(ETXLEN, len);
	MOVLW       2
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVF        FARG_TxPacket_len+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVF        FARG_TxPacket_len+1, 0 
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,495 :: 		do {
L_TxPacket68:
;PIC_Client.c,496 :: 		read = ReadReg(ECON1);
	MOVLW       30
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
;PIC_Client.c,497 :: 		} while (Read & ECON1_TXRTS);
	BTFSC       R0, 1 
	GOTO        L_TxPacket68
;PIC_Client.c,499 :: 		ChkLink();
	CALL        _ChkLink+0, 0
;PIC_Client.c,500 :: 		}
L_TxPacket67:
;PIC_Client.c,501 :: 		}
L_end_TxPacket:
	RETURN      0
; end of _TxPacket

_swapByteOrder:

;PIC_Client.c,503 :: 		unsigned long swapByteOrder(unsigned long ui) {
;PIC_Client.c,504 :: 		ui = (ui >> 24) |
	MOVF        FARG_swapByteOrder_ui+3, 0 
	MOVWF       R5 
	CLRF        R6 
	CLRF        R7 
	CLRF        R8 
;PIC_Client.c,505 :: 		((ui << 8) & 0x00FF0000) |
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
;PIC_Client.c,506 :: 		((ui >> 8) & 0x0000FF00) |
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
;PIC_Client.c,507 :: 		(ui << 24);
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
;PIC_Client.c,508 :: 		return ui;
;PIC_Client.c,509 :: 		}
L_end_swapByteOrder:
	RETURN      0
; end of _swapByteOrder

_SwapAddr:

;PIC_Client.c,511 :: 		void SwapAddr(PIpStruct ipData) {
;PIC_Client.c,514 :: 		for (i = 0; i <= 5; i++) {
	CLRF        R4 
L_SwapAddr71:
	MOVF        R4, 0 
	SUBLW       5
	BTFSS       STATUS+0, 0 
	GOTO        L_SwapAddr72
;PIC_Client.c,515 :: 		ipData->eth.DestMac[i] = ipData->eth.ScrMac[i];
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
;PIC_Client.c,516 :: 		ipData->eth.ScrMac[i] = MyMacAddr[i];
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
;PIC_Client.c,514 :: 		for (i = 0; i <= 5; i++) {
	INCF        R4, 1 
;PIC_Client.c,517 :: 		}
	GOTO        L_SwapAddr71
L_SwapAddr72:
;PIC_Client.c,518 :: 		for (i = 0; i <= 3; i++) {
	CLRF        R4 
L_SwapAddr74:
	MOVF        R4, 0 
	SUBLW       3
	BTFSS       STATUS+0, 0 
	GOTO        L_SwapAddr75
;PIC_Client.c,519 :: 		ipData->ip.DestAddr[i] = ipData->ip.ScrAddr[i];
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
;PIC_Client.c,520 :: 		ipData->ip.Scraddr[i] = MyIpAddr[i];
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
;PIC_Client.c,518 :: 		for (i = 0; i <= 3; i++) {
	INCF        R4, 1 
;PIC_Client.c,521 :: 		}
	GOTO        L_SwapAddr74
L_SwapAddr75:
;PIC_Client.c,522 :: 		}
L_end_SwapAddr:
	RETURN      0
; end of _SwapAddr

_CkSum:

;PIC_Client.c,525 :: 		unsigned int CkSum(unsigned offset, unsigned Len, unsigned short Seed) {
;PIC_Client.c,528 :: 		do {
L_CkSum77:
;PIC_Client.c,529 :: 		Read = ReadReg(ECON1);
	MOVLW       30
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
;PIC_Client.c,530 :: 		} while (Read & ECON1_DMAST);
	BTFSC       R0, 5 
	GOTO        L_CkSum77
;PIC_Client.c,532 :: 		BFCREG(ECON1, ECON1_DMACPY);
	MOVLW       30
	MOVWF       FARG_BFCReg_wAddress+0 
	MOVLW       16
	MOVWF       FARG_BFCReg_wBitMask+0 
	CALL        _BFCReg+0, 0
;PIC_Client.c,533 :: 		BFCREG(ECON1, ECON1_DMANOCS);
	MOVLW       30
	MOVWF       FARG_BFCReg_wAddress+0 
	MOVLW       4
	MOVWF       FARG_BFCReg_wBitMask+0 
	CALL        _BFCReg+0, 0
;PIC_Client.c,534 :: 		if (Seed)
	MOVF        FARG_CkSum_Seed+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_CkSum80
;PIC_Client.c,535 :: 		BFSREG(ECON1, ECON1_DMACSSD);
	MOVLW       30
	MOVWF       FARG_BFSReg_wAddress+0 
	MOVLW       8
	MOVWF       FARG_BFSReg_wBitMask+0 
	CALL        _BFSReg+0, 0
	GOTO        L_CkSum81
L_CkSum80:
;PIC_Client.c,537 :: 		BFCREG(ECON1, ECON1_DMACSSD);
	MOVLW       30
	MOVWF       FARG_BFCReg_wAddress+0 
	MOVLW       8
	MOVWF       FARG_BFCReg_wBitMask+0 
	CALL        _BFCReg+0, 0
L_CkSum81:
;PIC_Client.c,539 :: 		WriteReg(EDMAST, TXSTART + offset);
	MOVLW       10
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVF        FARG_CkSum_offset+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVF        FARG_CkSum_offset+1, 0 
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,540 :: 		WriteReg(EDMALEN, Len);
	MOVLW       12
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVF        FARG_CkSum_Len+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVF        FARG_CkSum_Len+1, 0 
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,542 :: 		BFSREG(ECON1, ECON1_DMAST);
	MOVLW       30
	MOVWF       FARG_BFSReg_wAddress+0 
	MOVLW       32
	MOVWF       FARG_BFSReg_wBitMask+0 
	CALL        _BFSReg+0, 0
;PIC_Client.c,543 :: 		do {
L_CkSum82:
;PIC_Client.c,544 :: 		read = ReadReg(ECON1);
	MOVLW       30
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
;PIC_Client.c,545 :: 		} while (Read & ECON1_DMAST);
	BTFSC       R0, 5 
	GOTO        L_CkSum82
;PIC_Client.c,547 :: 		read = (ReadReg(EDMACS));
	MOVLW       16
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
;PIC_Client.c,548 :: 		return read;
;PIC_Client.c,549 :: 		}
L_end_CkSum:
	RETURN      0
; end of _CkSum

_MACInit:

;PIC_Client.c,568 :: 		void MACInit(void) {
;PIC_Client.c,571 :: 		DeassertChipSelect();
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,573 :: 		ConfigureSPIModule();
	BCF         TRISC1_bit+0, BitPos(TRISC1_bit+0) 
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
	BCF         TRISC3_bit+0, BitPos(TRISC3_bit+0) 
	BSF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
	CLRF        SSP1CON1+0 
	MOVLW       64
	MOVWF       SSP1STAT+0 
	MOVLW       32
	MOVWF       SSP1CON1+0 
;PIC_Client.c,574 :: 		ClearSPIDoneFlag();
	BCF         PIR1+0, 3 
;PIC_Client.c,578 :: 		SendSystemReset();
	CALL        _SendSystemReset+0, 0
;PIC_Client.c,580 :: 		RegValue = ReadReg(MAADR1);
	MOVLW       100
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       _RegValue+0 
	MOVF        R1, 0 
	MOVWF       _RegValue+1 
;PIC_Client.c,581 :: 		myMacAddr[0] = LOW(RegValue);
	MOVLW       255
	ANDWF       R0, 0 
	MOVWF       _myMacAddr+0 
;PIC_Client.c,582 :: 		myMacAddr[1] = HIGH(RegValue);
	MOVF        R1, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       255
	ANDWF       R2, 0 
	MOVWF       _myMacAddr+1 
;PIC_Client.c,583 :: 		RegValue = ReadReg(MAADR2);
	MOVLW       98
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       _RegValue+0 
	MOVF        R1, 0 
	MOVWF       _RegValue+1 
;PIC_Client.c,584 :: 		myMacAddr[2] = LOW(RegValue);
	MOVLW       255
	ANDWF       R0, 0 
	MOVWF       _myMacAddr+2 
;PIC_Client.c,585 :: 		myMacAddr[3] = HIGH(RegValue);
	MOVF        R1, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       255
	ANDWF       R2, 0 
	MOVWF       _myMacAddr+3 
;PIC_Client.c,586 :: 		RegValue = ReadReg(MAADR3);
	MOVLW       96
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       _RegValue+0 
	MOVF        R1, 0 
	MOVWF       _RegValue+1 
;PIC_Client.c,587 :: 		myMacAddr[4] = LOW(RegValue);
	MOVLW       255
	ANDWF       R0, 0 
	MOVWF       _myMacAddr+4 
;PIC_Client.c,588 :: 		myMacAddr[5] = HIGH(RegValue);
	MOVF        R1, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       255
	ANDWF       R2, 0 
	MOVWF       _myMacAddr+5 
;PIC_Client.c,592 :: 		NextPacketPointer = RXSTART;
	MOVLW       64
	MOVWF       _NextPacketPointer+0 
	MOVLW       83
	MOVWF       _NextPacketPointer+1 
;PIC_Client.c,593 :: 		WriteReg(ETXST, TXSTART);
	CLRF        FARG_WriteReg_wAddress+0 
	CLRF        FARG_WriteReg_wValue+0 
	CLRF        FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,594 :: 		WriteReg(ERXST, RXSTART);
	MOVLW       4
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       64
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       83
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,595 :: 		WriteReg(ERXRDPT, RXSTART);
	MOVLW       138
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       64
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       83
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,596 :: 		WriteReg(ERXTAIL, RXEND - 2);
	MOVLW       6
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       253
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       95
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,601 :: 		WritePHYReg(PHANA, PHANA_ADPAUS0 | PHANA_AD10FD | PHANA_AD10 | PHANA_AD100FD | PHANA_AD100 | PHANA_ADIEEE0);
	MOVLW       4
	MOVWF       FARG_WritePHYReg_Register+0 
	MOVLW       225
	MOVWF       FARG_WritePHYReg_Data+0 
	CALL        _WritePHYReg+0, 0
;PIC_Client.c,604 :: 		EXECUTE0(ENABLERX);
	MOVLW       232
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
;PIC_Client.c,605 :: 		} //end MACInit
L_end_MACInit:
	RETURN      0
; end of _MACInit

_ChkPck:

;PIC_Client.c,607 :: 		unsigned ChkPck() {
;PIC_Client.c,610 :: 		RegValue = ReadReg(EIR);
	MOVLW       28
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       _RegValue+0 
	MOVF        R1, 0 
	MOVWF       _RegValue+1 
;PIC_Client.c,611 :: 		if (!(RegValue & EIR_PKTIF))
	BTFSC       R0, 6 
	GOTO        L_ChkPck94
;PIC_Client.c,613 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_ChkPck
;PIC_Client.c,614 :: 		}
L_ChkPck94:
;PIC_Client.c,616 :: 		RegValue = ReadReg(ESTAT);
	MOVLW       26
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       _RegValue+0 
	MOVF        R1, 0 
	MOVWF       _RegValue+1 
;PIC_Client.c,617 :: 		PckCnt = LOW(RegValue);
	MOVLW       255
	ANDWF       R0, 0 
	MOVWF       R0 
;PIC_Client.c,618 :: 		if (PckCnt) {
	BTFSC       STATUS+0, 2 
	GOTO        L_ChkPck95
;PIC_Client.c,619 :: 		PckLen = GetFrame();
	CALL        _GetFrame+0, 0
	MOVF        R0, 0 
	MOVWF       _PckLen+0 
	MOVF        R1, 0 
	MOVWF       _PckLen+1 
;PIC_Client.c,620 :: 		return PckLen;
	GOTO        L_end_ChkPck
;PIC_Client.c,621 :: 		}
L_ChkPck95:
;PIC_Client.c,622 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
;PIC_Client.c,623 :: 		}
L_end_ChkPck:
	RETURN      0
; end of _ChkPck

_GetFrame:

;PIC_Client.c,625 :: 		unsigned GetFrame() {
;PIC_Client.c,629 :: 		WriteReg(ERXRDPT, NextPacketPointer);
	MOVLW       138
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVF        _NextPacketPointer+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVF        _NextPacketPointer+1, 0 
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,631 :: 		ReadMemoryWindow(RX_WINDOW, PckHdr, 8);
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
;PIC_Client.c,632 :: 		RXData = (PRXStruct) PckHdr;
	MOVLW       GetFrame_PckHdr_L0+0
	MOVWF       _RXData+0 
	MOVLW       hi_addr(GetFrame_PckHdr_L0+0)
	MOVWF       _RXData+1 
;PIC_Client.c,634 :: 		NextPacketPointer = RXData->NextPtr;
	MOVFF       _RXData+0, FSR0
	MOVFF       _RXData+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       _NextPacketPointer+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       _NextPacketPointer+1 
;PIC_Client.c,635 :: 		RxLen = RXData->ByteCount;
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
;PIC_Client.c,636 :: 		if (RxLen > 200) Rxlen = 200;
	MOVLW       0
	MOVWF       R0 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GetFrame319
	MOVF        R1, 0 
	SUBLW       200
L__GetFrame319:
	BTFSC       STATUS+0, 0 
	GOTO        L_GetFrame96
	MOVLW       200
	MOVWF       GetFrame_RxLen_L0+0 
	MOVLW       0
	MOVWF       GetFrame_RxLen_L0+1 
L_GetFrame96:
;PIC_Client.c,638 :: 		ReadMemoryWindow(RX_WINDOW, packet, RxLen);
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
;PIC_Client.c,640 :: 		WriteReg(ERXTAIL, RXData->NextPtr - 2);
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
;PIC_Client.c,642 :: 		RxLen -= 4; //!!!!!!!!
	MOVLW       4
	SUBWF       GetFrame_RxLen_L0+0, 1 
	MOVLW       0
	SUBWFB      GetFrame_RxLen_L0+1, 1 
;PIC_Client.c,643 :: 		Execute0(SETPKTDEC);
	MOVLW       204
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
;PIC_Client.c,645 :: 		if (RXData->ReceiveOk) return (RxLen);
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
;PIC_Client.c,646 :: 		else return 0;
	CLRF        R0 
	CLRF        R1 
;PIC_Client.c,647 :: 		}
L_end_GetFrame:
	RETURN      0
; end of _GetFrame

_ChkLink:

;PIC_Client.c,671 :: 		void ChkLink(void) {
;PIC_Client.c,679 :: 		if (ReadReg(EIR) & EIR_LINKIF) {
	MOVLW       28
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	BTFSS       R1, 3 
	GOTO        L_ChkLink99
;PIC_Client.c,680 :: 		BFCReg(EIR, EIR_LINKIF);
	MOVLW       28
	MOVWF       FARG_BFCReg_wAddress+0 
	MOVLW       0
	MOVWF       FARG_BFCReg_wBitMask+0 
	CALL        _BFCReg+0, 0
;PIC_Client.c,683 :: 		w = ReadReg(MACON2);
	MOVLW       66
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       ChkLink_w_L0+0 
	MOVF        R1, 0 
	MOVWF       ChkLink_w_L0+1 
;PIC_Client.c,684 :: 		if (ReadReg(ESTAT) & ESTAT_PHYDPX) {
	MOVLW       26
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	BTFSS       R1, 2 
	GOTO        L_ChkLink100
;PIC_Client.c,686 :: 		WriteReg(MABBIPG, 0x15);
	MOVLW       68
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       21
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       0
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,687 :: 		w |= MACON2_FULDPX;
	BSF         ChkLink_w_L0+0, 0 
;PIC_Client.c,688 :: 		} else {
	GOTO        L_ChkLink101
L_ChkLink100:
;PIC_Client.c,690 :: 		WriteReg(MABBIPG, 0x12);
	MOVLW       68
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       18
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       0
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,691 :: 		w &= ~MACON2_FULDPX;
	BCF         ChkLink_w_L0+0, 0 
;PIC_Client.c,692 :: 		}
L_ChkLink101:
;PIC_Client.c,693 :: 		WriteReg(MACON2, w);
	MOVLW       66
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVF        ChkLink_w_L0+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVF        ChkLink_w_L0+1, 0 
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,694 :: 		}
L_ChkLink99:
;PIC_Client.c,705 :: 		do {
L_ChkLink102:
;PIC_Client.c,706 :: 		RegValue = ReadReg(ESTAT);
	MOVLW       26
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       _RegValue+0 
	MOVF        R1, 0 
	MOVWF       _RegValue+1 
;PIC_Client.c,707 :: 		} while (!(RegValue & ESTAT_PHYLNK));
	BTFSS       R1, 0 
	GOTO        L_ChkLink102
;PIC_Client.c,709 :: 		EXECUTE0(SETTXRTS);
	MOVLW       212
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
;PIC_Client.c,711 :: 		do {
L_ChkLink105:
;PIC_Client.c,712 :: 		RegValue = ReadReg(ECON1);
	MOVLW       30
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R0, 0 
	MOVWF       _RegValue+0 
	MOVF        R1, 0 
	MOVWF       _RegValue+1 
;PIC_Client.c,713 :: 		} while (RegValue & ECON1_TXRTS);
	BTFSC       R0, 1 
	GOTO        L_ChkLink105
;PIC_Client.c,714 :: 		}
L_end_ChkLink:
	RETURN      0
; end of _ChkLink

_SendSystemReset:

;PIC_Client.c,750 :: 		void SendSystemReset(void) {
;PIC_Client.c,752 :: 		do {
L_SendSystemReset108:
;PIC_Client.c,759 :: 		do {
L_SendSystemReset111:
;PIC_Client.c,760 :: 		WriteReg(EUDAST, 0x1234);
	MOVLW       22
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       52
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       18
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,761 :: 		} while (ReadReg(EUDAST) != 0x1234u);
	MOVLW       22
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVF        R1, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L__SendSystemReset322
	MOVLW       52
	XORWF       R0, 0 
L__SendSystemReset322:
	BTFSS       STATUS+0, 2 
	GOTO        L_SendSystemReset111
;PIC_Client.c,764 :: 		Execute0(SETETHRST);
	MOVLW       202
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
;PIC_Client.c,765 :: 		vCurrentBank = 0;
	CLRF        _vCurrentBank+0 
;PIC_Client.c,766 :: 		while ((ReadReg(ESTAT) & (ESTAT_CLKRDY | ESTAT_RSTDONE | ESTAT_PHYRDY)) != (ESTAT_CLKRDY | ESTAT_RSTDONE | ESTAT_PHYRDY));
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
	GOTO        L__SendSystemReset323
	MOVLW       0
	XORWF       R2, 0 
L__SendSystemReset323:
	BTFSC       STATUS+0, 2 
	GOTO        L_SendSystemReset115
	GOTO        L_SendSystemReset114
L_SendSystemReset115:
;PIC_Client.c,767 :: 		Delay_us(30);
	MOVLW       79
	MOVWF       R13, 0
L_SendSystemReset116:
	DECFSZ      R13, 1, 1
	BRA         L_SendSystemReset116
	NOP
	NOP
;PIC_Client.c,774 :: 		} while (ReadReg(EUDAST) != 0x0000u);
	MOVLW       22
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SendSystemReset324
	MOVLW       0
	XORWF       R0, 0 
L__SendSystemReset324:
	BTFSS       STATUS+0, 2 
	GOTO        L_SendSystemReset108
;PIC_Client.c,777 :: 		Delay_Ms(1);
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
;PIC_Client.c,779 :: 		} //end SendSystemReset
L_end_SendSystemReset:
	RETURN      0
; end of _SendSystemReset

_ReadReg:

;PIC_Client.c,799 :: 		unsigned ReadReg(unsigned short int wAddress) {
;PIC_Client.c,806 :: 		vBank = ((unsigned char) wAddress) & 0xE0;
	MOVLW       224
	ANDWF       FARG_ReadReg_wAddress+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       ReadReg_vBank_L1+0 
;PIC_Client.c,807 :: 		if (vBank <= (0x3u << 5)) {
	MOVF        R1, 0 
	SUBLW       96
	BTFSS       STATUS+0, 0 
	GOTO        L_ReadReg118
;PIC_Client.c,808 :: 		if (vBank != vCurrentBank) {
	MOVF        ReadReg_vBank_L1+0, 0 
	XORWF       _vCurrentBank+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_ReadReg119
;PIC_Client.c,809 :: 		if (vBank == (0x0u << 5))
	MOVF        ReadReg_vBank_L1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadReg120
;PIC_Client.c,810 :: 		Execute0(B0SEL);
	MOVLW       192
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_ReadReg121
L_ReadReg120:
;PIC_Client.c,811 :: 		else if (vBank == (0x1u << 5))
	MOVF        ReadReg_vBank_L1+0, 0 
	XORLW       32
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadReg122
;PIC_Client.c,812 :: 		Execute0(B1SEL);
	MOVLW       194
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_ReadReg123
L_ReadReg122:
;PIC_Client.c,813 :: 		else if (vBank == (0x2u << 5))
	MOVF        ReadReg_vBank_L1+0, 0 
	XORLW       64
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadReg124
;PIC_Client.c,814 :: 		Execute0(B2SEL);
	MOVLW       196
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_ReadReg125
L_ReadReg124:
;PIC_Client.c,815 :: 		else if (vBank == (0x3u << 5))
	MOVF        ReadReg_vBank_L1+0, 0 
	XORLW       96
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadReg126
;PIC_Client.c,816 :: 		Execute0(B3SEL);
	MOVLW       198
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
L_ReadReg126:
L_ReadReg125:
L_ReadReg123:
L_ReadReg121:
;PIC_Client.c,818 :: 		vCurrentBank = vBank;
	MOVF        ReadReg_vBank_L1+0, 0 
	MOVWF       _vCurrentBank+0 
;PIC_Client.c,819 :: 		}
L_ReadReg119:
;PIC_Client.c,821 :: 		w = Execute2(RCR | (wAddress & 0x1F), 0x0000);
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
;PIC_Client.c,822 :: 		} else {
	GOTO        L_ReadReg127
L_ReadReg118:
;PIC_Client.c,823 :: 		unsigned long dw = Execute3(RCRU, (unsigned short int) wAddress);
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
;PIC_Client.c,824 :: 		((unsigned char * ) & w)[0] = ((unsigned char * ) & dw)[1];
	MOVF        ReadReg_dw_L2+1, 0 
	MOVWF       ReadReg_w_L1+0 
;PIC_Client.c,825 :: 		((unsigned char * ) & w)[1] = ((unsigned char * ) & dw)[2];
	MOVF        ReadReg_dw_L2+2, 0 
	MOVWF       ReadReg_w_L1+1 
;PIC_Client.c,826 :: 		}
L_ReadReg127:
;PIC_Client.c,828 :: 		return w;
	MOVF        ReadReg_w_L1+0, 0 
	MOVWF       R0 
	MOVF        ReadReg_w_L1+1, 0 
	MOVWF       R1 
;PIC_Client.c,830 :: 		} //end ReadReg
L_end_ReadReg:
	RETURN      0
; end of _ReadReg

_ReadMemoryWindow:

;PIC_Client.c,856 :: 		void ReadMemoryWindow(unsigned short vWindow, unsigned short * vData, unsigned wLength) {
;PIC_Client.c,859 :: 		vOpcode = RBMUDA;
	MOVLW       48
	MOVWF       ReadMemoryWindow_vOpcode_L0+0 
;PIC_Client.c,860 :: 		if (vWindow == GP_WINDOW)
	MOVF        FARG_ReadMemoryWindow_vWindow+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadMemoryWindow128
;PIC_Client.c,861 :: 		vOpcode = RBMGP;
	MOVLW       40
	MOVWF       ReadMemoryWindow_vOpcode_L0+0 
L_ReadMemoryWindow128:
;PIC_Client.c,862 :: 		if (vWindow == RX_WINDOW)
	MOVF        FARG_ReadMemoryWindow_vWindow+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadMemoryWindow129
;PIC_Client.c,863 :: 		vOpcode = RBMRX;
	MOVLW       44
	MOVWF       ReadMemoryWindow_vOpcode_L0+0 
L_ReadMemoryWindow129:
;PIC_Client.c,865 :: 		ReadN(vOpcode, vData, wLength);
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
;PIC_Client.c,866 :: 		}
L_end_ReadMemoryWindow:
	RETURN      0
; end of _ReadMemoryWindow

_ReadN:

;PIC_Client.c,868 :: 		void ReadN(unsigned char vOpcode, unsigned char * vData, unsigned wDataLen) {
;PIC_Client.c,871 :: 		AssertChipSelect();
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,872 :: 		ClearSPIDoneFlag();
	BCF         PIR1+0, 3 
;PIC_Client.c,873 :: 		SSPBUF = vOpcode; // Send the command/opcode
	MOVF        FARG_ReadN_vOpcode+0, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,874 :: 		WaitForDatabyte();
L_ReadN139:
	BTFSC       PIR1+0, 3 
	GOTO        L_ReadN140
	GOTO        L_ReadN139
L_ReadN140:
	BCF         PIR1+0, 3 
;PIC_Client.c,875 :: 		vDummy = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R2 
;PIC_Client.c,876 :: 		while (wDataLen--) {
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
;PIC_Client.c,877 :: 		SSPBUF = 0x00;
	CLRF        SSP1BUF+0 
;PIC_Client.c,878 :: 		WaitForDatabyte(); * vData = SSPBUF;
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
;PIC_Client.c,879 :: 		vData++;
	INFSNZ      FARG_ReadN_vData+0, 1 
	INCF        FARG_ReadN_vData+1, 1 
;PIC_Client.c,880 :: 		}
	GOTO        L_ReadN141
L_ReadN142:
;PIC_Client.c,881 :: 		DeassertChipSelect();
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,884 :: 		}
L_end_ReadN:
	RETURN      0
; end of _ReadN

_ReadPHYReg:

;PIC_Client.c,903 :: 		unsigned ReadPHYReg(unsigned char Register) {
;PIC_Client.c,907 :: 		WriteReg(MIREGADR, 0x0100 | Register);
	MOVLW       84
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       0
	IORWF       FARG_ReadPHYReg_Register+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       0
	IORLW       1
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,908 :: 		WriteReg(MICMD, MICMD_MIIRD);
	MOVLW       82
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       1
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       0
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,912 :: 		while (ReadReg(MISTAT) & MISTAT_BUSY);
L_ReadPHYReg151:
	MOVLW       106
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	BTFSS       R0, 0 
	GOTO        L_ReadPHYReg152
	GOTO        L_ReadPHYReg151
L_ReadPHYReg152:
;PIC_Client.c,915 :: 		WriteReg(MICMD, 0x0000);
	MOVLW       82
	MOVWF       FARG_WriteReg_wAddress+0 
	CLRF        FARG_WriteReg_wValue+0 
	CLRF        FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,918 :: 		wResult = ReadReg(MIRD);
	MOVLW       104
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
;PIC_Client.c,920 :: 		return wResult;
;PIC_Client.c,921 :: 		} //end ReadPHYReg
L_end_ReadPHYReg:
	RETURN      0
; end of _ReadPHYReg

_WriteReg:

;PIC_Client.c,941 :: 		void WriteReg(unsigned short int wAddress, unsigned wValue) {
;PIC_Client.c,947 :: 		vBank = ((unsigned char) wAddress) & 0xE0;
	MOVLW       224
	ANDWF       FARG_WriteReg_wAddress+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       WriteReg_vBank_L1+0 
;PIC_Client.c,948 :: 		if (vBank <= (0x3u << 5)) {
	MOVF        R1, 0 
	SUBLW       96
	BTFSS       STATUS+0, 0 
	GOTO        L_WriteReg153
;PIC_Client.c,949 :: 		if (vBank != vCurrentBank) {
	MOVF        WriteReg_vBank_L1+0, 0 
	XORWF       _vCurrentBank+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_WriteReg154
;PIC_Client.c,950 :: 		if (vBank == (0x0u << 5))
	MOVF        WriteReg_vBank_L1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteReg155
;PIC_Client.c,951 :: 		Execute0(B0SEL);
	MOVLW       192
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_WriteReg156
L_WriteReg155:
;PIC_Client.c,952 :: 		else if (vBank == (0x1u << 5))
	MOVF        WriteReg_vBank_L1+0, 0 
	XORLW       32
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteReg157
;PIC_Client.c,953 :: 		Execute0(B1SEL);
	MOVLW       194
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_WriteReg158
L_WriteReg157:
;PIC_Client.c,954 :: 		else if (vBank == (0x2u << 5))
	MOVF        WriteReg_vBank_L1+0, 0 
	XORLW       64
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteReg159
;PIC_Client.c,955 :: 		Execute0(B2SEL);
	MOVLW       196
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_WriteReg160
L_WriteReg159:
;PIC_Client.c,956 :: 		else if (vBank == (0x3u << 5))
	MOVF        WriteReg_vBank_L1+0, 0 
	XORLW       96
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteReg161
;PIC_Client.c,957 :: 		Execute0(B3SEL);
	MOVLW       198
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
L_WriteReg161:
L_WriteReg160:
L_WriteReg158:
L_WriteReg156:
;PIC_Client.c,959 :: 		vCurrentBank = vBank;
	MOVF        WriteReg_vBank_L1+0, 0 
	MOVWF       _vCurrentBank+0 
;PIC_Client.c,960 :: 		}
L_WriteReg154:
;PIC_Client.c,962 :: 		Execute2(WCR | (wAddress & 0x1F), wValue);
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
;PIC_Client.c,963 :: 		} else {
	GOTO        L_WriteReg162
L_WriteReg153:
;PIC_Client.c,965 :: 		((unsigned char * ) & dw)[0] = (unsigned char) wAddress;
	MOVF        FARG_WriteReg_wAddress+0, 0 
	MOVWF       WriteReg_dw_L2+0 
;PIC_Client.c,966 :: 		((unsigned char * ) & dw)[1] = ((unsigned char * ) & wValue)[0];
	MOVF        FARG_WriteReg_wValue+0, 0 
	MOVWF       WriteReg_dw_L2+1 
;PIC_Client.c,967 :: 		((unsigned char * ) & dw)[2] = ((unsigned char * ) & wValue)[1];
	MOVF        FARG_WriteReg_wValue+1, 0 
	MOVWF       WriteReg_dw_L2+2 
;PIC_Client.c,968 :: 		Execute3(WCRU, dw);
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
;PIC_Client.c,969 :: 		}
L_WriteReg162:
;PIC_Client.c,972 :: 		} //end WriteReg
L_end_WriteReg:
	RETURN      0
; end of _WriteReg

_WriteMemoryWindow:

;PIC_Client.c,996 :: 		void WriteMemoryWindow(unsigned short vWindow, unsigned short * vData, unsigned wLength) {
;PIC_Client.c,999 :: 		vOpcode = WBMUDA;
	MOVLW       50
	MOVWF       WriteMemoryWindow_vOpcode_L0+0 
;PIC_Client.c,1000 :: 		if (vWindow & GP_WINDOW)
	BTFSS       FARG_WriteMemoryWindow_vWindow+0, 1 
	GOTO        L_WriteMemoryWindow163
;PIC_Client.c,1001 :: 		vOpcode = WBMGP;
	MOVLW       42
	MOVWF       WriteMemoryWindow_vOpcode_L0+0 
L_WriteMemoryWindow163:
;PIC_Client.c,1002 :: 		if (vWindow & RX_WINDOW)
	BTFSS       FARG_WriteMemoryWindow_vWindow+0, 2 
	GOTO        L_WriteMemoryWindow164
;PIC_Client.c,1003 :: 		vOpcode = WBMRX;
	MOVLW       46
	MOVWF       WriteMemoryWindow_vOpcode_L0+0 
L_WriteMemoryWindow164:
;PIC_Client.c,1005 :: 		WriteN(vOpcode, vData, wLength);
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
;PIC_Client.c,1006 :: 		}
L_end_WriteMemoryWindow:
	RETURN      0
; end of _WriteMemoryWindow

_WriteN:

;PIC_Client.c,1008 :: 		void WriteN(unsigned char vOpcode, unsigned short * vData, unsigned wDataLen) {
;PIC_Client.c,1011 :: 		AssertChipSelect();
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,1012 :: 		ClearSPIDoneFlag();
	BCF         PIR1+0, 3 
;PIC_Client.c,1013 :: 		SSPBUF = vOpcode; // Send the command/opcode
	MOVF        FARG_WriteN_vOpcode+0, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1014 :: 		WaitForDatabyte();
L_WriteN174:
	BTFSC       PIR1+0, 3 
	GOTO        L_WriteN175
	GOTO        L_WriteN174
L_WriteN175:
	BCF         PIR1+0, 3 
;PIC_Client.c,1015 :: 		vDummy = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R2 
;PIC_Client.c,1017 :: 		while (wDataLen--) {
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
;PIC_Client.c,1018 :: 		SSPBUF = * vData++;
	MOVFF       FARG_WriteN_vData+0, FSR0
	MOVFF       FARG_WriteN_vData+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       SSP1BUF+0 
	INFSNZ      FARG_WriteN_vData+0, 1 
	INCF        FARG_WriteN_vData+1, 1 
;PIC_Client.c,1019 :: 		WaitForDatabyte();
L_WriteN181:
	BTFSC       PIR1+0, 3 
	GOTO        L_WriteN182
	GOTO        L_WriteN181
L_WriteN182:
	BCF         PIR1+0, 3 
;PIC_Client.c,1020 :: 		vDummy = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R2 
;PIC_Client.c,1021 :: 		}
	GOTO        L_WriteN176
L_WriteN177:
;PIC_Client.c,1022 :: 		DeassertChipSelect();
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,1024 :: 		}
L_end_WriteN:
	RETURN      0
; end of _WriteN

_WritePHYReg:

;PIC_Client.c,1044 :: 		void WritePHYReg(unsigned char Register, unsigned short int Data) {
;PIC_Client.c,1046 :: 		WriteReg(MIREGADR, 0x0100 | Register);
	MOVLW       84
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVLW       0
	IORWF       FARG_WritePHYReg_Register+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       0
	IORLW       1
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,1049 :: 		WriteReg(MIWR, Data);
	MOVLW       102
	MOVWF       FARG_WriteReg_wAddress+0 
	MOVF        FARG_WritePHYReg_Data+0, 0 
	MOVWF       FARG_WriteReg_wValue+0 
	MOVLW       0
	MOVWF       FARG_WriteReg_wValue+1 
	CALL        _WriteReg+0, 0
;PIC_Client.c,1052 :: 		while (ReadReg(MISTAT) & MISTAT_BUSY);
L_WritePHYReg186:
	MOVLW       106
	MOVWF       FARG_ReadReg_wAddress+0 
	CALL        _ReadReg+0, 0
	BTFSS       R0, 0 
	GOTO        L_WritePHYReg187
	GOTO        L_WritePHYReg186
L_WritePHYReg187:
;PIC_Client.c,1053 :: 		} //end WritePHYReg
L_end_WritePHYReg:
	RETURN      0
; end of _WritePHYReg

_BFSReg:

;PIC_Client.c,1072 :: 		void BFSReg(unsigned short int wAddress, unsigned short int wBitMask) {
;PIC_Client.c,1078 :: 		vBank = ((unsigned char) wAddress) & 0xE0;
	MOVLW       224
	ANDWF       FARG_BFSReg_wAddress+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       BFSReg_vBank_L1+0 
;PIC_Client.c,1079 :: 		if (vBank != vCurrentBank) {
	MOVF        R1, 0 
	XORWF       _vCurrentBank+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_BFSReg188
;PIC_Client.c,1080 :: 		if (vBank == (0x0u << 5))
	MOVF        BFSReg_vBank_L1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_BFSReg189
;PIC_Client.c,1081 :: 		Execute0(B0SEL);
	MOVLW       192
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_BFSReg190
L_BFSReg189:
;PIC_Client.c,1082 :: 		else if (vBank == (0x1u << 5))
	MOVF        BFSReg_vBank_L1+0, 0 
	XORLW       32
	BTFSS       STATUS+0, 2 
	GOTO        L_BFSReg191
;PIC_Client.c,1083 :: 		Execute0(B1SEL);
	MOVLW       194
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_BFSReg192
L_BFSReg191:
;PIC_Client.c,1084 :: 		else if (vBank == (0x2u << 5))
	MOVF        BFSReg_vBank_L1+0, 0 
	XORLW       64
	BTFSS       STATUS+0, 2 
	GOTO        L_BFSReg193
;PIC_Client.c,1085 :: 		Execute0(B2SEL);
	MOVLW       196
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_BFSReg194
L_BFSReg193:
;PIC_Client.c,1086 :: 		else if (vBank == (0x3u << 5))
	MOVF        BFSReg_vBank_L1+0, 0 
	XORLW       96
	BTFSS       STATUS+0, 2 
	GOTO        L_BFSReg195
;PIC_Client.c,1087 :: 		Execute0(B3SEL);
	MOVLW       198
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
L_BFSReg195:
L_BFSReg194:
L_BFSReg192:
L_BFSReg190:
;PIC_Client.c,1089 :: 		vCurrentBank = vBank;
	MOVF        BFSReg_vBank_L1+0, 0 
	MOVWF       _vCurrentBank+0 
;PIC_Client.c,1090 :: 		}
L_BFSReg188:
;PIC_Client.c,1092 :: 		Execute2(BFS | (wAddress & 0x1F), wBitMask);
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
;PIC_Client.c,1094 :: 		} //end BFSReg
L_end_BFSReg:
	RETURN      0
; end of _BFSReg

_BFCReg:

;PIC_Client.c,1096 :: 		void BFCReg(unsigned short int wAddress, unsigned short int wBitMask) {
;PIC_Client.c,1102 :: 		vBank = ((unsigned char) wAddress) & 0xE0;
	MOVLW       224
	ANDWF       FARG_BFCReg_wAddress+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       BFCReg_vBank_L1+0 
;PIC_Client.c,1103 :: 		if (vBank != vCurrentBank) {
	MOVF        R1, 0 
	XORWF       _vCurrentBank+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_BFCReg196
;PIC_Client.c,1104 :: 		if (vBank == (0x0u << 5))
	MOVF        BFCReg_vBank_L1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_BFCReg197
;PIC_Client.c,1105 :: 		Execute0(B0SEL);
	MOVLW       192
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_BFCReg198
L_BFCReg197:
;PIC_Client.c,1106 :: 		else if (vBank == (0x1u << 5))
	MOVF        BFCReg_vBank_L1+0, 0 
	XORLW       32
	BTFSS       STATUS+0, 2 
	GOTO        L_BFCReg199
;PIC_Client.c,1107 :: 		Execute0(B1SEL);
	MOVLW       194
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_BFCReg200
L_BFCReg199:
;PIC_Client.c,1108 :: 		else if (vBank == (0x2u << 5))
	MOVF        BFCReg_vBank_L1+0, 0 
	XORLW       64
	BTFSS       STATUS+0, 2 
	GOTO        L_BFCReg201
;PIC_Client.c,1109 :: 		Execute0(B2SEL);
	MOVLW       196
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
	GOTO        L_BFCReg202
L_BFCReg201:
;PIC_Client.c,1110 :: 		else if (vBank == (0x3u << 5))
	MOVF        BFCReg_vBank_L1+0, 0 
	XORLW       96
	BTFSS       STATUS+0, 2 
	GOTO        L_BFCReg203
;PIC_Client.c,1111 :: 		Execute0(B3SEL);
	MOVLW       198
	MOVWF       FARG_Execute0_vOpcode+0 
	CALL        _Execute0+0, 0
L_BFCReg203:
L_BFCReg202:
L_BFCReg200:
L_BFCReg198:
;PIC_Client.c,1113 :: 		vCurrentBank = vBank;
	MOVF        BFCReg_vBank_L1+0, 0 
	MOVWF       _vCurrentBank+0 
;PIC_Client.c,1114 :: 		}
L_BFCReg196:
;PIC_Client.c,1116 :: 		Execute2(BFC | (wAddress & 0x1F), wBitMask);
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
;PIC_Client.c,1118 :: 		}
L_end_BFCReg:
	RETURN      0
; end of _BFCReg

_Execute0:

;PIC_Client.c,1136 :: 		void Execute0(unsigned char vOpcode) {
;PIC_Client.c,1139 :: 		AssertChipSelect();
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,1140 :: 		ClearSPIDoneFlag();
	BCF         PIR1+0, 3 
;PIC_Client.c,1141 :: 		SSPBUF = vOpcode; // Send the command/opcode
	MOVF        FARG_Execute0_vOpcode+0, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1142 :: 		WaitForDatabyte();
L_Execute0213:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute0214
	GOTO        L_Execute0213
L_Execute0214:
	BCF         PIR1+0, 3 
;PIC_Client.c,1143 :: 		vDummy = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R0 
;PIC_Client.c,1144 :: 		DeassertChipSelect();
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,1147 :: 		} //end Execute0
L_end_Execute0:
	RETURN      0
; end of _Execute0

_Execute2:

;PIC_Client.c,1149 :: 		unsigned Execute2(unsigned char vOpcode, unsigned wData) {
;PIC_Client.c,1152 :: 		AssertChipSelect();
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,1153 :: 		ClearSPIDoneFlag();
	BCF         PIR1+0, 3 
;PIC_Client.c,1154 :: 		SSPBUF = vOpcode; // Send the command/opcode
	MOVF        FARG_Execute2_vOpcode+0, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1155 :: 		WaitForDatabyte();
L_Execute2227:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute2228
	GOTO        L_Execute2227
L_Execute2228:
	BCF         PIR1+0, 3 
;PIC_Client.c,1156 :: 		((unsigned char * ) & wReturn)[0] = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R2 
;PIC_Client.c,1157 :: 		SSPBUF = ((unsigned char * ) & wData)[0]; // Send low unsigned char of data
	MOVF        FARG_Execute2_wData+0, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1158 :: 		WaitForDatabyte();
L_Execute2232:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute2233
	GOTO        L_Execute2232
L_Execute2233:
	BCF         PIR1+0, 3 
;PIC_Client.c,1159 :: 		((unsigned char * ) & wReturn)[0] = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R2 
;PIC_Client.c,1160 :: 		SSPBUF = ((unsigned char * ) & wData)[1]; // Send high unsigned char of data
	MOVF        FARG_Execute2_wData+1, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1161 :: 		WaitForDatabyte();
L_Execute2237:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute2238
	GOTO        L_Execute2237
L_Execute2238:
	BCF         PIR1+0, 3 
;PIC_Client.c,1162 :: 		((unsigned char * ) & wReturn)[1] = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R3 
;PIC_Client.c,1163 :: 		DeassertChipSelect();
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,1164 :: 		return wReturn;
	MOVF        R2, 0 
	MOVWF       R0 
	MOVF        R3, 0 
	MOVWF       R1 
;PIC_Client.c,1165 :: 		} //end Execute2
L_end_Execute2:
	RETURN      0
; end of _Execute2

_Execute3:

;PIC_Client.c,1167 :: 		unsigned long Execute3(unsigned char vOpcode, unsigned long dwData) {
;PIC_Client.c,1170 :: 		AssertChipSelect();
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,1171 :: 		ClearSPIDoneFlag();
	BCF         PIR1+0, 3 
;PIC_Client.c,1172 :: 		SSPBUF = vOpcode; // Send the command/opcode
	MOVF        FARG_Execute3_vOpcode+0, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1173 :: 		((unsigned char * ) & dwReturn)[3] = 0x00;
	CLRF        R7 
;PIC_Client.c,1174 :: 		WaitForDatabyte();
L_Execute3251:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute3252
	GOTO        L_Execute3251
L_Execute3252:
	BCF         PIR1+0, 3 
;PIC_Client.c,1175 :: 		((unsigned char * ) & dwReturn)[0] = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R4 
;PIC_Client.c,1176 :: 		SSPBUF = ((unsigned char * ) & dwData)[0]; // Send unsigned char 0 of data
	MOVF        FARG_Execute3_dwData+0, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1177 :: 		WaitForDatabyte();
L_Execute3256:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute3257
	GOTO        L_Execute3256
L_Execute3257:
	BCF         PIR1+0, 3 
;PIC_Client.c,1178 :: 		((unsigned char * ) & dwReturn)[0] = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R4 
;PIC_Client.c,1179 :: 		SSPBUF = ((unsigned char * ) & dwData)[1]; // Send unsigned char 1 of data
	MOVF        FARG_Execute3_dwData+1, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1180 :: 		WaitForDatabyte();
L_Execute3261:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute3262
	GOTO        L_Execute3261
L_Execute3262:
	BCF         PIR1+0, 3 
;PIC_Client.c,1181 :: 		((unsigned char * ) & dwReturn)[1] = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R5 
;PIC_Client.c,1182 :: 		SSPBUF = ((unsigned char * ) & dwData)[2]; // Send unsigned char 2 of data
	MOVF        FARG_Execute3_dwData+2, 0 
	MOVWF       SSP1BUF+0 
;PIC_Client.c,1183 :: 		WaitForDatabyte();
L_Execute3266:
	BTFSC       PIR1+0, 3 
	GOTO        L_Execute3267
	GOTO        L_Execute3266
L_Execute3267:
	BCF         PIR1+0, 3 
;PIC_Client.c,1184 :: 		((unsigned char * ) & dwReturn)[2] = SSPBUF;
	MOVF        SSP1BUF+0, 0 
	MOVWF       R6 
;PIC_Client.c,1185 :: 		DeassertChipSelect();
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;PIC_Client.c,1187 :: 		return dwReturn;
	MOVF        R4, 0 
	MOVWF       R0 
	MOVF        R5, 0 
	MOVWF       R1 
	MOVF        R6, 0 
	MOVWF       R2 
	MOVF        R7, 0 
	MOVWF       R3 
;PIC_Client.c,1188 :: 		} //end Execute2
L_end_Execute3:
	RETURN      0
; end of _Execute3

_WriteReg_Hex:

;PIC_Client.c,1192 :: 		void WriteReg_Hex(unsigned char * kommandoTekst, unsigned char Register) {
;PIC_Client.c,1193 :: 		strcpy(buffer, kommandoTekst);
	MOVLW       _buffer+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_strcpy_to+1 
	MOVF        FARG_WriteReg_Hex_kommandoTekst+0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        FARG_WriteReg_Hex_kommandoTekst+1, 0 
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;PIC_Client.c,1194 :: 		WordtoHex(ReadReg(Register), HexStr);
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
;PIC_Client.c,1195 :: 		strcat(buffer, HexStr);
	MOVLW       _buffer+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       _HexStr+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(_HexStr+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;PIC_Client.c,1196 :: 		UART1_Write_Text(buffer);
	MOVLW       _buffer+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1197 :: 		}
L_end_WriteReg_Hex:
	RETURN      0
; end of _WriteReg_Hex

_ENC100DumpState:

;PIC_Client.c,1199 :: 		void ENC100DumpState(void) {
;PIC_Client.c,1200 :: 		strcpy(buffer, "\r\n  Next Packet Pointer    = 0x");
	MOVLW       _buffer+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr38_PIC_Client+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr38_PIC_Client+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;PIC_Client.c,1201 :: 		WordtoHex(NextPacketPointer, HexStr);
	MOVF        _NextPacketPointer+0, 0 
	MOVWF       FARG_WordToHex_input+0 
	MOVF        _NextPacketPointer+1, 0 
	MOVWF       FARG_WordToHex_input+1 
	MOVLW       _HexStr+0
	MOVWF       FARG_WordToHex_output+0 
	MOVLW       hi_addr(_HexStr+0)
	MOVWF       FARG_WordToHex_output+1 
	CALL        _WordToHex+0, 0
;PIC_Client.c,1202 :: 		strcat(buffer, HexStr);
	MOVLW       _buffer+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       _HexStr+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(_HexStr+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;PIC_Client.c,1203 :: 		UART1_Write_Text(buffer);
	MOVLW       _buffer+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1204 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr39_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr39_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1205 :: 		WriteReg_Hex("\r\n EIR     = 0x", EIR);
	MOVLW       ?lstr40_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr40_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       28
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1207 :: 		WriteReg_Hex("\r\n ERXST   = 0x", ERXST);
	MOVLW       ?lstr41_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr41_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       4
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1208 :: 		WriteReg_Hex("\r\n ERXRDPT = 0x", ERXRDPT);
	MOVLW       ?lstr42_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr42_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       138
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1209 :: 		WriteReg_Hex("\r\n ERXWRPT = 0x", ERXWRPT);
	MOVLW       ?lstr43_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr43_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       140
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1210 :: 		WriteReg_Hex("\r\n ERXTAIL = 0x", ERXTAIL);
	MOVLW       ?lstr44_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr44_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       6
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1211 :: 		WriteReg_Hex("\r\n ERXHEAD = 0x", ERXHEAD);
	MOVLW       ?lstr45_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr45_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       8
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1212 :: 		WriteReg_Hex("\r\n ESTAT   = 0x", ESTAT);
	MOVLW       ?lstr46_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr46_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       26
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1213 :: 		WriteReg_Hex("\r\n ERXFCON = 0x", ERXFCON);
	MOVLW       ?lstr47_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr47_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       52
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1214 :: 		WriteReg_Hex("\r\n MACON1  = 0x", MACON1);
	MOVLW       ?lstr48_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr48_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       64
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1215 :: 		WriteReg_Hex("\r\n MACON2  = 0x", MACON2);
	MOVLW       ?lstr49_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr49_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       66
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1216 :: 		WriteReg_Hex("\r\n ECON1   = 0x", ECON1);
	MOVLW       ?lstr50_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr50_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       30
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1217 :: 		WriteReg_Hex("\r\n ECON2   = 0x", ECON2);
	MOVLW       ?lstr51_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr51_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       110
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1218 :: 		WriteReg_Hex("\r\n ETXST   = 0x", ETXST);
	MOVLW       ?lstr52_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr52_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	CLRF        FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1219 :: 		WriteReg_Hex("\r\n ETXLEN  = 0x", ETXLEN);
	MOVLW       ?lstr53_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr53_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       2
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1220 :: 		WriteReg_Hex("\r\n EDMAST  = 0x", EDMAST);
	MOVLW       ?lstr54_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr54_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       10
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1221 :: 		WriteReg_Hex("\r\n EDMALEN = 0x", EDMALEN);
	MOVLW       ?lstr55_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr55_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       12
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1222 :: 		WriteReg_Hex("\r\n EDMADST = 0x", EDMADST);
	MOVLW       ?lstr56_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr56_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       14
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1223 :: 		WriteReg_Hex("\r\n EDMACS  = 0x", EDMACS);
	MOVLW       ?lstr57_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr57_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       16
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1224 :: 		WriteReg_Hex("\r\n MAADR3  = 0x", MAADR3);
	MOVLW       ?lstr58_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr58_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       96
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1225 :: 		WriteReg_Hex("\r\n MAADR2  = 0x", MAADR2);
	MOVLW       ?lstr59_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr59_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       98
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1226 :: 		WriteReg_Hex("\r\n MAADR1  = 0x", MAADR1);
	MOVLW       ?lstr60_PIC_Client+0
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+0 
	MOVLW       hi_addr(?lstr60_PIC_Client+0)
	MOVWF       FARG_WriteReg_Hex_kommandoTekst+1 
	MOVLW       100
	MOVWF       FARG_WriteReg_Hex_Register+0 
	CALL        _WriteReg_Hex+0, 0
;PIC_Client.c,1228 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr61_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr61_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1229 :: 		}
L_end_ENC100DumpState:
	RETURN      0
; end of _ENC100DumpState

_ShowPacket:

;PIC_Client.c,1231 :: 		void ShowPacket(unsigned short* Buffer, unsigned len)
;PIC_Client.c,1236 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr62_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr62_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1237 :: 		LinI = 0x00;
	CLRF        ShowPacket_LinI_L0+0 
	CLRF        ShowPacket_LinI_L0+1 
;PIC_Client.c,1238 :: 		for(PacI=0;PacI<len;++PacI)
	CLRF        ShowPacket_PacI_L0+0 
	CLRF        ShowPacket_PacI_L0+1 
L_ShowPacket271:
	MOVF        FARG_ShowPacket_len+1, 0 
	SUBWF       ShowPacket_PacI_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ShowPacket341
	MOVF        FARG_ShowPacket_len+0, 0 
	SUBWF       ShowPacket_PacI_L0+0, 0 
L__ShowPacket341:
	BTFSC       STATUS+0, 0 
	GOTO        L_ShowPacket272
;PIC_Client.c,1240 :: 		ByteToHex(Buffer[PacI], tal);
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
;PIC_Client.c,1241 :: 		UART1_Write_Text(tal);
	MOVLW       ShowPacket_tal_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(ShowPacket_tal_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1242 :: 		UART1_Write_Text (" ");
	MOVLW       ?lstr63_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr63_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1243 :: 		if(++LinI == 0x10)
	INFSNZ      ShowPacket_LinI_L0+0, 1 
	INCF        ShowPacket_LinI_L0+1, 1 
	MOVLW       0
	XORWF       ShowPacket_LinI_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ShowPacket342
	MOVLW       16
	XORWF       ShowPacket_LinI_L0+0, 0 
L__ShowPacket342:
	BTFSS       STATUS+0, 2 
	GOTO        L_ShowPacket274
;PIC_Client.c,1245 :: 		LinI = 0x00;
	CLRF        ShowPacket_LinI_L0+0 
	CLRF        ShowPacket_LinI_L0+1 
;PIC_Client.c,1246 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr64_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr64_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1247 :: 		}
L_ShowPacket274:
;PIC_Client.c,1238 :: 		for(PacI=0;PacI<len;++PacI)
	INFSNZ      ShowPacket_PacI_L0+0, 1 
	INCF        ShowPacket_PacI_L0+1, 1 
;PIC_Client.c,1248 :: 		}
	GOTO        L_ShowPacket271
L_ShowPacket272:
;PIC_Client.c,1249 :: 		UART1_Write_Text("\n\r");
	MOVLW       ?lstr65_PIC_Client+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr65_PIC_Client+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_Client.c,1250 :: 		}
L_end_ShowPacket:
	RETURN      0
; end of _ShowPacket

_ClrPacket:

;PIC_Client.c,1252 :: 		void ClrPacket()
;PIC_Client.c,1255 :: 		Len = 200;
	MOVLW       200
	MOVWF       R2 
	MOVLW       0
	MOVWF       R3 
;PIC_Client.c,1256 :: 		do
L_ClrPacket275:
;PIC_Client.c,1258 :: 		Packet[Len] = 0;
	MOVLW       _Packet+0
	ADDWF       R2, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_Packet+0)
	ADDWFC      R3, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;PIC_Client.c,1259 :: 		} while (Len --);
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
;PIC_Client.c,1262 :: 		}
L_end_ClrPacket:
	RETURN      0
; end of _ClrPacket
