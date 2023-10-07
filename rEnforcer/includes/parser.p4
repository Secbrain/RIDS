#ifndef _PARSER_H_
#define _PARSER_H_

#define ETHERTYPE_IPV4 0x0800
#define IP_PROTOCOLS_TCP 6
#define IP_PROTOCOLS_UDP 17

parser start {
    return parse_ethernet;
}

header ethernet_t ethernet;
parser parse_ethernet {
    extract(ethernet);
    return select(latest.ether_type) {
        ETHERTYPE_IPV4 : parse_ipv4;  
        default: ingress;
    }
}

header ipv4_t ipv4;
parser parse_ipv4 {
    extract(ipv4);
    //could set metadata in parser process
    //set_metadata(forward_md.dst_ip, ipv4.dst_ip);
    return select(latest.proto) {
        IP_PROTOCOLS_TCP : parse_tcp;
        IP_PROTOCOLS_UDP : parse_udp;
        default: ingress;
    }
}

header tcp_t tcp;
parser parse_tcp {
    extract(tcp);
    return parse_payload8b;
    //return ingress;
}

header udp_t udp;
parser parse_udp {
    extract(udp);
    return parse_payload8b;
    //return ingress;
}

header payload8b_t payload8b;
parser parse_payload8b {
    extract(payload8b);
    return ingress;
}
#endif
