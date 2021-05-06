CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET VERIFY OFF;

DECLARE
	A FrequentPackets.Total_Fwd_Packets%TYPE := &Ttl_Fwd_Pckt;
	B FrequentPackets.Total_Backward_Packets%TYPE := &Total_Bwd_Pckt;
	C FrequentPackets.Total_Length_of_Fwd_Packets%TYPE := &Ttl_Len_of_Fwd_Pckt;
	D FrequentPackets.Total_Length_of_Bwd_Packets%TYPE := &Ttl_Len_of_Bwd_Pckt;
	E FrequentPackets.Fwd_Packet_Length_Max%TYPE := &Fwd_Pckt_Len_Max;
	F FrequentPackets.Fwd_Packets_s%TYPE := &Fwd_Packets_s;
	LBL FrequentPackets.Label%TYPE := '&label';
	Freq FrequentPackets.Frequency%TYPE := '&frequency';
	
BEGIN
	Insert_Proc(A,B,C,D,E,F,LBL,Freq);
END;
/