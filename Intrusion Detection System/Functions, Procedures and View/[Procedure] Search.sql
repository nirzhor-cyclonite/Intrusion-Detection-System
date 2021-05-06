SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE Search_DB(A IN FrequentPackets.Total_Fwd_Packets%TYPE, B IN FrequentPackets.Total_Backward_Packets%TYPE,
										C IN FrequentPackets.Total_Length_of_Fwd_Packets%TYPE, D IN FrequentPackets.Total_Length_of_Bwd_Packets%TYPE,
										E IN FrequentPackets.Fwd_Packet_Length_Max%TYPE, F IN FrequentPackets.Fwd_Packets_s%TYPE,
										lbl OUT FrequentPackets.Label%TYPE, freq OUT FrequentPackets.Frequency%TYPE, IS_SEARCH IN INTEGER)
	IS

BEGIN
SELECT Label into LBL FROM
	FrequentPackets WHERE Total_Fwd_Packets = A
	AND Total_Backward_Packets = B
	AND Total_Length_of_Fwd_Packets = C
	AND Total_Length_of_Bwd_Packets = D
	AND Fwd_Packet_Length_Max = E
	AND Fwd_Packets_s = F;
	
	IF LBL = 'Benign' THEN
		IF IS_SEARCH = 1 THEN
			DBMS_OUTPUT.PUT_LINE('It is a normal packet');
		END IF;
	ELSIF LBL = 'Attack' THEN
		IF IS_SEARCH = 1 THEN
			DBMS_OUTPUT.PUT_LINE('It is a malicious packet');
		END IF;
		--USE OF VIEW, View is on Server--
		SELECT Label INTO LBL FROM FrequentAttacks WHERE Ttl_Fwd_Pckt = A 
		AND Total_Bwd_Pckt = B AND Ttl_Len_of_Fwd_Pckt = C 
		AND Ttl_Len_of_Bwd_Pckt = D AND Fwd_Pckt_Len_Max = E
		AND Fwd_Packets_s = F;
		IF IS_SEARCH = 1 THEN
			DBMS_OUTPUT.PUT_LINE('Attack Class: ' || LBL);
		END IF;
	END IF;
	freq := 'Frequent';
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		freq := 'Infrequent';
		IF IS_SEARCH = 1 THEN
			DBMS_OUTPUT.PUT_LINE('Packet does not appear frequently');
		END IF;
		IF(SearchBenign(A,B,C,D,E,F) = 1) THEN
			IF IS_SEARCH = 1 THEN
				DBMS_OUTPUT.PUT_LINE('It is a normal packet');
			END IF;
		ELSE
			Search_Malicious(A,B,C,D,E,F,LBL,IS_SEARCH);
			DBMS_OUTPUT.PUT_LINE('');
			IF IS_SEARCH = 1 THEN
				DBMS_OUTPUT.PUT_LINE('Attack Class: ' || LBL);
			END IF;
			--DBMS_OUTPUT.PUT_LINE('It is a malicious packet');
		END IF;
END Search_DB;
/