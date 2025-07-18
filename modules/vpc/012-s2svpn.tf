
# resource "aws_customer_gateway" "dflight-customer_gw" {
#   bgp_asn    = 65000
#   ip_address = aws_instance.openswan-aws_instance.public_ip # IP customer gateway da cambiare se serve
#   type       = "ipsec.1"
#   tags = {
#     Name = "CustomerGateway_Dflight"
#   }
# }

# resource "aws_vpn_gateway" "dflight-vpn_gw" {
#   vpc_id = aws_vpc.this.id
#   tags = {
#     Name = "VirtualPrivateGateway"
#   }
# }

# # Attach Virtual Private Gateway to VPC
# resource "aws_vpn_gateway_attachment" "dflight-vpn_gw_attach" {
#   vpc_id         = aws_vpc.this.id
#   vpn_gateway_id = aws_vpn_gateway.dflight-vpn_gw.id
# }

# resource "aws_vpn_connection" "dflight-vpn_connection" {
#   customer_gateway_id = aws_customer_gateway.dflight-customer_gw.id
#   vpn_gateway_id      = aws_vpn_gateway.dflight-vpn_gw.id
#   type                = "ipsec.1"

#   tags = {
#     Name = "VPNConnection"
#   }
# }

# # Add a VPN Static Route (For Private Subnets)
# resource "aws_vpn_connection_route" "vpn_route" {
#   destination_cidr_block = aws_vpc.demo-vpc-onprem.cidr_block # on-prem network
#   vpn_connection_id      = aws_vpn_connection.dflight-vpn_connection.id
# }

# #TO ADD routing tables for the VPN

