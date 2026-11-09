variable "project" {
    default = "roboshop"
}

variable "environment" {
    default = "dev"
}

variable "sg_names" {
    type = list
    default = [
        "mongodb", "redis", "mysql", "rabbitmq",
        #"catalogue", "user", "cart", "shipping", "payment",
        #"backend_alb",
        #"frontend",
        "public_nlb",
        "bastion",
        "eks_control_plane",
        "eks_node",
        "jenkins", "jenkins_agent", "sonar",
        "runner"
        #"vpn"
    ]
}