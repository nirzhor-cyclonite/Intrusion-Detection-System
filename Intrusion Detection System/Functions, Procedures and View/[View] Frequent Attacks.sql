--Add site link when going in distribute mode

CREATE OR REPLACE VIEW FrequentAttacks (Ttl_Fwd_Pckt, Total_Bwd_Pckt, Ttl_Len_of_Fwd_Pckt, Ttl_Len_of_Bwd_Pckt, Fwd_Pckt_Len_Max, Fwd_Packets_s, Label) AS
SELECT Total_Fwd_Packets, Total_Backward_Packets, Total_Length_of_Fwd_Packets, Total_Length_of_Bwd_Packets, 
Fwd_Packet_Length_Max, Fwd_Packets_s, Label FROM 
(SELECT * FROM DoS@site_link UNION 
SELECT * FROM Port_Scan@site_link UNION 
SELECT * FROM Web_Attack@site_link UNION 
SELECT * FROM Brute_Force@site_link ) WHERE Frequency = 'Frequent';

COMMIT;