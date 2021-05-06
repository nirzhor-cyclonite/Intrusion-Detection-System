CREATE OR REPLACE FUNCTION SearchBenign(Ttl_Fwd_Pckt IN FrequentPackets.Total_Fwd_Packets%TYPE, Total_Bwd_Pckt IN FrequentPackets.Total_Backward_Packets%TYPE,
										Ttl_Len_of_Fwd_Pckt IN FrequentPackets.Total_Length_of_Fwd_Packets%TYPE, Ttl_Len_of_Bwd_Pckt IN FrequentPackets.Total_Length_of_Bwd_Packets%TYPE,
										Fwd_Pckt_Len_Max IN FrequentPackets.Fwd_Packet_Length_Max%TYPE, Fwd_Pckt_s IN FrequentPackets.Fwd_Packets_s%TYPE)
						RETURN INTEGER
						IS
						FLAG INTEGER;
						
	BEGIN
		FLAG := 0;
		FOR R IN (SELECT Label FROM BENIGN_PACKETS@site_link WHERE Total_Fwd_Packets = Ttl_Fwd_Pckt AND Total_Backward_Packets = Total_Bwd_Pckt
			AND Total_Length_of_Fwd_Packets = Ttl_Len_of_Fwd_Pckt AND Total_Length_of_Bwd_Packets = Ttl_Len_of_Bwd_Pckt
			AND Fwd_Packet_Length_Max = Fwd_Pckt_Len_Max AND Fwd_Packets_s = Fwd_Pckt_s) LOOP
			FLAG :=1;
		END LOOP;
	RETURN FLAG;
	END SearchBenign;
/