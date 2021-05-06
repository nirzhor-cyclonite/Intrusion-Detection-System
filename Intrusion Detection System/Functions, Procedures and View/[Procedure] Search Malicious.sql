SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE Search_Malicious(Ttl_Fwd_Pckt IN FrequentPackets.Total_Fwd_Packets%TYPE, Total_Bwd_Pckt IN FrequentPackets.Total_Backward_Packets%TYPE,
										Ttl_Len_of_Fwd_Pckt IN FrequentPackets.Total_Length_of_Fwd_Packets%TYPE, Ttl_Len_of_Bwd_Pckt IN FrequentPackets.Total_Length_of_Bwd_Packets%TYPE,
										Fwd_Pckt_Len_Max IN FrequentPackets.Fwd_Packet_Length_Max%TYPE, Fwd_Pckt_s IN FrequentPackets.Fwd_Packets_s%TYPE,
										lbl OUT FrequentPackets.Label%TYPE, IS_SEARCH IN INTEGER)
	IS
BEGIN
	SELECT Label into lbl FROM (SELECT * FROM DoS@site_link UNION 
			SELECT * FROM Port_Scan@site_link UNION 
			SELECT * FROM Web_Attack@site_link UNION 
			SELECT * FROM Brute_Force@site_link)WHERE 
			Total_Fwd_Packets = Ttl_Fwd_Pckt AND Total_Backward_Packets = Total_Bwd_Pckt
			AND Total_Length_of_Fwd_Packets = Ttl_Len_of_Fwd_Pckt AND Total_Length_of_Bwd_Packets = Ttl_Len_of_Bwd_Pckt
			AND Fwd_Packet_Length_Max = Fwd_Pckt_Len_Max AND Fwd_Packets_s = Fwd_Pckt_s;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		IF IS_SEARCH = 1 THEN
			DBMS_OUTPUT.PUT_LINE('Unknown Packet, predicted to be: ');
			KNN(Ttl_Fwd_Pckt,Total_Bwd_Pckt,Ttl_Len_of_Fwd_Pckt,Ttl_Len_of_Bwd_Pckt,Fwd_Pckt_Len_Max,Fwd_Pckt_s,lbl,IS_SEARCH );
		ELSE
			lbl := 'Unknown Packet';
		END IF;
		
END Search_Malicious;
/