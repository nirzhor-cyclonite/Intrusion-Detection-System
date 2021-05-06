SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE Delete_Proc (Ttl_Fwd_Pckt IN FrequentPackets.Total_Fwd_Packets%TYPE, Total_Bwd_Pckt IN FrequentPackets.Total_Backward_Packets%TYPE,
										Ttl_Len_of_Fwd_Pckt IN FrequentPackets.Total_Length_of_Fwd_Packets%TYPE, Ttl_Len_of_Bwd_Pckt IN FrequentPackets.Total_Length_of_Bwd_Packets%TYPE,
										Fwd_Pckt_Len_Max IN FrequentPackets.Fwd_Packet_Length_Max%TYPE, Fwd_Pckt_s IN FrequentPackets.Fwd_Packets_s%TYPE)
	IS
	LBL FrequentPackets.Label%TYPE;
	Freq FrequentPackets.Frequency%TYPE;
BEGIN
Search_DB(Ttl_Fwd_Pckt,Total_Bwd_Pckt,Ttl_Len_of_Fwd_Pckt,Ttl_Len_of_Bwd_Pckt,Fwd_Pckt_Len_Max,Fwd_Pckt_s,LBL,Freq,0);
IF LBL = 'Unknown Packet' THEN
	DBMS_OUTPUT.PUT_LINE('No such packet exist in the database');
ELSE
	IF LBL = 'Benign' THEN
		IF Freq = 'Frequent' THEN
			DELETE FROM FrequentPackets WHERE Total_Fwd_Packets = Ttl_Fwd_Pckt AND Total_Backward_Packets = Total_Bwd_Pckt AND Total_Length_of_Fwd_Packets = Ttl_Len_of_Fwd_Pckt AND Total_Length_of_Bwd_Packets = Ttl_Len_of_Bwd_Pckt AND Fwd_Packet_Length_Max = Fwd_Pckt_Len_Max AND Fwd_Packets_s = Fwd_Pckt_s;
			DELETE FROM BENIGN_PACKETS@site_link WHERE Total_Fwd_Packets = Ttl_Fwd_Pckt AND Total_Backward_Packets = Total_Bwd_Pckt AND Total_Length_of_Fwd_Packets = Ttl_Len_of_Fwd_Pckt AND Total_Length_of_Bwd_Packets = Ttl_Len_of_Bwd_Pckt AND Fwd_Packet_Length_Max = Fwd_Pckt_Len_Max AND Fwd_Packets_s = Fwd_Pckt_s;
			DBMS_OUTPUT.PUT_LINE('Deleted from Frequent Packets table on server');
			DBMS_OUTPUT.PUT_LINE('Deleted from Benign Packets table on site');
		ELSIF Freq = 'Infrequent' THEN
			DELETE FROM BENIGN_PACKETS@site_link WHERE Total_Fwd_Packets = Ttl_Fwd_Pckt AND Total_Backward_Packets = Total_Bwd_Pckt AND Total_Length_of_Fwd_Packets = Ttl_Len_of_Fwd_Pckt AND Total_Length_of_Bwd_Packets = Ttl_Len_of_Bwd_Pckt AND Fwd_Packet_Length_Max = Fwd_Pckt_Len_Max AND Fwd_Packets_s = Fwd_Pckt_s;
 			DBMS_OUTPUT.PUT_LINE('Deleted from Benign Packets table on site');
		END IF;
	ELSE
		IF LBL = 'DoS' THEN
			DELETE FROM DoS@site_link WHERE Total_Fwd_Packets = Ttl_Fwd_Pckt AND Total_Backward_Packets = Total_Bwd_Pckt AND Total_Length_of_Fwd_Packets = Ttl_Len_of_Fwd_Pckt AND Total_Length_of_Bwd_Packets = Ttl_Len_of_Bwd_Pckt AND Fwd_Packet_Length_Max = Fwd_Pckt_Len_Max AND Fwd_Packets_s = Fwd_Pckt_s;		
			DBMS_OUTPUT.PUT_LINE('Deleted from DoS table on site');
		ELSIF LBL = 'PortScan' THEN
			DELETE FROM Port_Scan@site_link WHERE Total_Fwd_Packets = Ttl_Fwd_Pckt AND Total_Backward_Packets = Total_Bwd_Pckt AND Total_Length_of_Fwd_Packets = Ttl_Len_of_Fwd_Pckt AND Total_Length_of_Bwd_Packets = Ttl_Len_of_Bwd_Pckt AND Fwd_Packet_Length_Max = Fwd_Pckt_Len_Max AND Fwd_Packets_s = Fwd_Pckt_s;
			DBMS_OUTPUT.PUT_LINE('Deleted from Port Scan table on site');
		ELSIF LBL = 'Web Attack' THEN
			DELETE FROM Web_Attack@site_link WHERE Total_Fwd_Packets = Ttl_Fwd_Pckt AND Total_Backward_Packets = Total_Bwd_Pckt AND Total_Length_of_Fwd_Packets = Ttl_Len_of_Fwd_Pckt AND Total_Length_of_Bwd_Packets = Ttl_Len_of_Bwd_Pckt AND Fwd_Packet_Length_Max = Fwd_Pckt_Len_Max AND Fwd_Packets_s = Fwd_Pckt_s;
			DBMS_OUTPUT.PUT_LINE('Deleted from Web Attack table on site');
		ELSIF LBL = 'Brute Force' THEN
			DELETE FROM Brute_Force@site_link WHERE Total_Fwd_Packets = Ttl_Fwd_Pckt AND Total_Backward_Packets = Total_Bwd_Pckt AND Total_Length_of_Fwd_Packets = Ttl_Len_of_Fwd_Pckt AND Total_Length_of_Bwd_Packets = Ttl_Len_of_Bwd_Pckt AND Fwd_Packet_Length_Max = Fwd_Pckt_Len_Max AND Fwd_Packets_s = Fwd_Pckt_s;
			DBMS_OUTPUT.PUT_LINE('Deleted from Brute Force table on site');
		END IF;
		IF Freq = 'Frequent' THEN
			DELETE FROM FrequentPackets WHERE Total_Fwd_Packets = Ttl_Fwd_Pckt AND Total_Backward_Packets = Total_Bwd_Pckt AND Total_Length_of_Fwd_Packets = Ttl_Len_of_Fwd_Pckt AND Total_Length_of_Bwd_Packets = Ttl_Len_of_Bwd_Pckt AND Fwd_Packet_Length_Max = Fwd_Pckt_Len_Max AND Fwd_Packets_s = Fwd_Pckt_s;
			DBMS_OUTPUT.PUT_LINE('Also deleted from Frequent Packets table on server');
		END IF;
	END IF;
END IF;
COMMIT;	
END Delete_Proc;
/