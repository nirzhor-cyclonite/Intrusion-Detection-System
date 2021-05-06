DROP TABLE BENIGN_PACKETS;

CREATE TABLE BENIGN_PACKETS(
	Total_Fwd_Packets integer,
	Total_Backward_Packets integer,
	Total_Length_of_Fwd_Packets integer,
	Total_Length_of_Bwd_Packets integer,
	Fwd_Packet_Length_Max integer,
	Fwd_Packets_s number,
	Label varchar2(100),
	Frequency varchar2(100)
);

COMMIT;