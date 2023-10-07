#ifndef _HEADERS_H_
#define _HEADERS_H_

header_type ethernet_t {
    fields {
        dst_addr : 48;
        src_addr : 48;
        ether_type : 16;
    }
}

header_type ipv4_t {
    fields {
        version : 4;
        ihl : 4;
        diffserv : 6;
        ecn : 2;
        total_len : 16;
        identification : 16;
        flags : 3;
        frag_offset : 13;
        ttl : 8;
        proto : 8;
        checksum : 16;
        src_ip : 32;
        dst_ip: 32;
    }
}

header_type tcp_t {
    fields {
        src_port : 16;
        dst_port : 16;
        seq_no : 32;
        ack_no : 32;
        data_offset : 4;
        res : 3;
        ecn : 3;
        ctrl : 6;
        window : 16;
        checksum : 16;
        urgent_ptr : 16;
    }
}

header_type udp_t {
    fields {
        src_port : 16;
        dst_port : 16;
        hdr_length : 16;
        checksum : 16;
    }
}

header_type payload8b_t {
    fields {
	b1 : 8;
	b2 : 8;
	b3 : 8;
	b4 : 8;
	b5 : 8;
	b6 : 8;
	b7 : 8;
	b8 : 8;
    }
}

#endif
