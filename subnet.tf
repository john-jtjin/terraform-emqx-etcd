# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "dev-igw"
    Environment = "dev"
  }
}

# public subnet
resource "aws_subnet" "public-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.4.0.0/19"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags = {
    EnvType     = "dev"
    Name        = "indochat-dev-public-1a"
    ServiceName = "indochat"
  }
}
resource "aws_subnet" "public-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.4.32.0/19"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true
  tags = {
    EnvType     = "dev"
    Name        = "indochat-dev-public-1b"
    ServiceName = "indochat"

  }
}

# private subnet
resource "aws_subnet" "private-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.4.64.0/19"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false
  tags = {
    EnvType     = "dev"
    Name        = "indochat-dev-private-1a"
    ServiceName = "indochat"

  }
}
resource "aws_subnet" "private-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.4.96.0/19"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = false
  tags = {
    EnvType     = "dev"
    Name        = "indochat-dev-private-1b"
    ServiceName = "indochat"

  }
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "dev-private-route-table"
    Environment = "dev"
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "dev-public-route-table"
    Environment = "dev"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

# Route table associations for both Public & Private Subnets
resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-1b" {
  subnet_id      = aws_subnet.public-1b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.private-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-1b" {
  subnet_id      = aws_subnet.private-1b.id
  route_table_id = aws_route_table.private.id
}