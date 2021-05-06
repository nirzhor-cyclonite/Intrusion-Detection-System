SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE KNN(Ttl_Fwd_Pckt IN FrequentPackets.Total_Fwd_Packets%TYPE, Total_Bwd_Pckt IN FrequentPackets.Total_Backward_Packets%TYPE,
										Ttl_Len_of_Fwd_Pckt IN FrequentPackets.Total_Length_of_Fwd_Packets%TYPE, Ttl_Len_of_Bwd_Pckt IN FrequentPackets.Total_Length_of_Bwd_Packets%TYPE,
										Fwd_Pckt_Len_Max IN FrequentPackets.Fwd_Packet_Length_Max%TYPE, Fwd_Pckt_s IN FrequentPackets.Fwd_Packets_s%TYPE,
										lbl OUT FrequentPackets.Label%TYPE, IS_SEARCH IN INTEGER)
		IS
		distance NUMBER;
		A TEMP.LABEL%TYPE :='';
		B TEMP.DISTANCE%TYPE:=0;
BEGIN
	DELETE FROM TEMP;
	FOR R IN ((SELECT * FROM DoS@site_link UNION 
			SELECT * FROM Port_Scan@site_link UNION 
			SELECT * FROM Web_Attack@site_link UNION 
			SELECT * FROM Brute_Force@site_link )) LOOP
			distance := SQRT(POWER((R.Total_Fwd_Packets-Ttl_Fwd_Pckt),2) + POWER((R.Total_Backward_Packets-Total_Bwd_Pckt),2) +
									POWER((R.Total_Length_of_Fwd_Packets-Ttl_Len_of_Fwd_Pckt),2) + POWER((R.Total_Length_of_Bwd_Packets-Ttl_Len_of_Bwd_Pckt),2) +
									POWER((R.Fwd_Packet_Length_Max-Fwd_Pckt_Len_Max),2) + POWER((R.Fwd_Packets_s-Fwd_Pckt_s),2));
			INSERT INTO TEMP VALUES (R.Label, distance);
	END LOOP;
	FOR R IN (SELECT LABEL, COUNT(LABEL) AS CNT FROM (SELECT Label FROM (SELECT * FROM TEMP ORDER BY DISTANCE) WHERE ROWNUM<6) GROUP BY LABEL) LOOP
		IF R.CNT> B THEN
			A:= R.LABEL;
			B:= R.CNT;
		END IF;
	END LOOP;
	lbl:=A;
	IF IS_SEARCH = 1 THEN
		DBMS_OUTPUT.PUT_LINE(A);
		DBMS_OUTPUT.PUT_LINE('Contains '||B||' similar neighbours');
	END IF;
	IF B>=4 THEN
		Insert_Proc(Ttl_Fwd_Pckt,Total_Bwd_Pckt,Ttl_Len_of_Fwd_Pckt,Ttl_Len_of_Bwd_Pckt,Fwd_Pckt_Len_Max,Fwd_Pckt_s,A, 'Infrequent');
	END IF;
END;
/