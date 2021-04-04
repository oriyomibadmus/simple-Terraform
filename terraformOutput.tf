output "publicip" {
    value = "${aws_instance.web-server-instance.public_ip}"
}