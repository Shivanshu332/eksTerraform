resource "aws_vpc" "eks_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name= "eks_vpc"
    }
}

resource "aws_subnet" "eks_public_subnet" {
    cidr_block = var.subnet_cidr_public
    vpc_id = aws_vpc.eks_vpc.id
    availability_zone = "ap-south-1a"
    tags = {
        Name = "eks_public_subnet"
        "kubernetes.io/role/elb" = "1"
    }
}

resource "aws_subnet" "eks_public_subnet-1b" {
    cidr_block = var.subnet_cidr_public_1b
    vpc_id = aws_vpc.eks_vpc.id
    availability_zone = "ap-south-1b"
    tags = {
        Name = "eks_public_subnet-1b"
        "kubernetes.io/role/elb" = "1"
    }
}

resource "aws_subnet" "eks_private_subnet" {
    cidr_block = var.subnet_cidr_private
    vpc_id = aws_vpc.eks_vpc.id
    availability_zone = "ap-south-1a"
    tags = {
        Name = "eks_private_subnet"
        "kubernetes.io/role/internal-elb" = 1
    }
}

resource "aws_subnet" "eks_private_subnet-1b" {
    cidr_block = var.subnet_cidr_private_1b
    vpc_id = aws_vpc.eks_vpc.id
    availability_zone = "ap-south-1b"
    tags = {
        Name = "eks_private_subnet-1b"
        "kubernetes.io/role/internal-elb" = 1
    }
}


resource "aws_internet_gateway" "eks_internet_gw" {
    vpc_id = aws_vpc.eks_vpc.id
    tags = {
        Name = "eks_internet_gw"
    }
}

resource "aws_nat_gateway" "eks_nat_gw" {
    vpc_id = aws_vpc.eks_vpc.id
    availability_mode = "regional"
    tags = {
        Name = "eks_nat_gw"
    }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.eks_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.eks_internet_gw.id
    }
    tags = {
      Name = "eks_public_rt"
    }
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.eks_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.eks_nat_gw.id
    }
    tags = {
      Name = "eks_private_rt"
    }
}



resource "aws_route_table_association" "public_rt_association" {
    route_table_id = aws_route_table.public_route_table.id
    subnet_id = aws_subnet.eks_public_subnet.id
}

resource "aws_route_table_association" "private_rt_association" {
    route_table_id = aws_route_table.private_route_table.id
    subnet_id = aws_subnet.eks_private_subnet.id
}

resource "aws_route_table_association" "public_rt_association_1b" {
    route_table_id = aws_route_table.public_route_table.id
    subnet_id = aws_subnet.eks_public_subnet-1b.id
}

resource "aws_route_table_association" "private_rt_association_1b" {
    route_table_id = aws_route_table.private_route_table.id
    subnet_id = aws_subnet.eks_private_subnet-1b.id
}