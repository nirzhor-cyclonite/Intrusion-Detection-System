SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE Insert_Proc (Ttl_Fwd_Pckt IN FrequentPackets.Total_Fwd_Packets%TYPE, Total_Bwd_Pckt IN FrequentPackets.Total_Backward_Packets%TYPE,
										Ttl_Len_of_Fwd_Pckt IN FrequentPackets.Total_Length_of_Fwd_Packets%TYPE, Ttl_Len_of_Bwd_Pckt IN FrequentPackets.Total_Length_of_Bwd_Packets%TYPE,
										Fwd_Pckt_Len_Max IN FrequentPackets.Fwd_Packet_Length_Max%TYPE, Fwd_Packets_s IN FrequentPackets.Fwd_Packets_s%TYPE,
										Label IN FrequentPackets.Label%TYPE, Frequency IN FrequentPackets.Frequency%TYPE)
	IS
BEGIN
	IF Label = 'Benign' THEN
		IF Frequency = 'Frequent' THEN
			INSERT INTO FrequentPackets VALUES (Ttl_Fwd_Pckt,Total_Bwd_Pckt,Ttl_Len_of_Fwd_Pckt,Ttl_Len_of_Bwd_Pckt,Fwd_Pckt_Len_Max,Fwd_Packets_s,Label,Frequency);
			INSERT INTO BENIGN_PACKETS@site_link VALUES (Ttl_Fwd_Pckt,Total_Bwd_Pckt,Ttl_Len_of_Fwd_Pckt,Ttl_Len_of_Bwd_Pckt,Fwd_Pckt_Len_Max,Fwd_Packets_s,Label,Frequency);
			DBMS_OUTPUT.PUT_LINE('Inserted to Frequent Packets table on server');
			DBMS_OUTPUT.PUT_LINE('Inserted to Benign Packets table on site');
		ELSIF Frequency = 'Infrequent' THEN
			INSERT INTO BENIGN_PACKETS@site_link VALUES (Ttl_Fwd_Pckt,Total_Bwd_Pckt,Ttl_Len_of_Fwd_Pckt,Ttl_Len_of_Bwd_Pckt,Fwd_Pckt_Len_Max,Fwd_Packets_s,Label,Frequency);		
			DBMS_OUTPUT.PUT_LINE('Inserted to Benign Packets table on site');
		END IF;
	ELSE
		IF Label = 'DoS' THEN
			INSERT INTO DoS@site_link VALUES (Ttl_Fwd_Pckt,Total_Bwd_Pckt,Ttl_Len_of_Fwd_Pckt,Ttl_Len_of_Bwd_Pckt,Fwd_Pckt_Len_Max,Fwd_Packets_s,Label,Frequency);
			DBMS_OUTPUT.PUT_LINE('Inserted to DoS table on site');
		ELSIF Label = 'PortScan' THEN
			INSERT INTO Port_Scan@site_link VALUES (Ttl_Fwd_Pckt,Total_Bwd_Pckt,Ttl_Len_of_Fwd_Pckt,Ttl_Len_of_Bwd_Pckt,Fwd_Pckt_Len_Max,Fwd_Packets_s,Label,Frequency);
			DBMS_OUTPUT.PUT_LINE('Inserted to Port Scan table on site');
		ELSIF Label = 'Web Attack' THEN
			INSERT INTO Web_Attack@site_link VALUES (Ttl_Fwd_Pckt,Total_Bwd_Pckt,Ttl_Len_of_Fwd_Pckt,Ttl_Len_of_Bwd_Pckt,Fwd_Pckt_Len_Max,Fwd_Packets_s,Label,Frequency);
			DBMS_OUTPUT.PUT_LINE('Inserted to Web Attack table on site');
		ELSIF Label = 'Brute Force' THEN
			INSERT INTO Brute_Force@site_link VALUES (Ttl_Fwd_Pckt,Total_Bwd_Pckt,Ttl_Len_of_Fwd_Pckt,Ttl_Len_of_Bwd_Pckt,Fwd_Pckt_Len_Max,Fwd_Packets_s,Label,Frequency);
			DBMS_OUTPUT.PUT_LINE('Inserted to Brute Force table on site');
		END IF;
		IF Frequency = 'Frequent' THEN
			INSERT INTO FrequentPackets VALUES (Ttl_Fwd_Pckt,Total_Bwd_Pckt,Ttl_Len_of_Fwd_Pckt,Ttl_Len_of_Bwd_Pckt,Fwd_Pckt_Len_Max,Fwd_Packets_s,'Attack',Frequency);
			DBMS_OUTPUT.PUT_LINE('Also Inserted to Frequent Packets table on server');
		END IF;
	END IF;
COMMIT;
END Insert_Proc;
/
