create database CarWorkshop;
use CarWorkshop;

CREATE TABLE Clients(
	idClient INT auto_increment NOT NULL,
    CPF CHAR(11) NOT NULL,
    fname VARCHAR(20) NOT NULL,
    minit VARCHAR(3),
    lname VARCHAR(30) NOT NULL,
    phoneNumber CHAR(11),
    
    constraint pk_idClient primary key (idClient),
    constraint unique_cpf_client UNIQUE (CPF)
);

CREATE TABLE Manager(
	idManager INT auto_increment NOT NULL,
    fname VARCHAR(20) NOT NULL,
    lname VARCHAR(30) NOT NULL,
    CPF CHAR(11) NOT NULL,
    Bdate DATE,
    startDate DATE NOT NULL, 
    
    constraint pk_idManager primary key (idManager),
    constraint unique_CPF_manager UNIQUE (CPF)
);
    
CREATE TABLE Part(
	idPart INT auto_increment NOT NULL,
    partName VARCHAR(45) NOT NULL,
    unitPrice DECIMAL(10,2) NOT NULL,
    stockQuantity INT NOT NULL,
    
    constraint pk_idPart primary key (idPart)
);
    
CREATE TABLE Service(
	idService INT auto_increment NOT NULL,
    serviceName VARCHAR(45) NOT NULL,
    serviceDescription VARCHAR(45),
    price DECIMAL(10,2) NOT NULL,
    
    constraint pk_idService primary key (idService)
);
  
CREATE TABLE Car(
	idCar INT auto_increment NOT NULL,
    carPlate CHAR(7) NOT NULL,
    idClient INT NOT NULL,
    carBrand VARCHAR(45) NOT NULL,
    model VARCHAR(45) NOT NULL,
    fabricationYear VARCHAR(9),
    color VARCHAR(20) NOT NULL,
    
    constraint pk_idCar primary key (idCar),
    constraint unique_carPlate UNIQUE (carPlate),
    constraint fk_car_idclient foreign key (idClient) references Clients(idClient)
);

CREATE TABLE Workshop(
	idWorkshop INT auto_increment NOT NULL,
    idManager INT NOT NULL,
    workshopName VARCHAR(45),
    CNPJ CHAR(14) NOT NULL,
    location VARCHAR(80) NOT NULL,
    
    constraint pk_idWorkshop primary key (idWorkshop),
    constraint fk_workshop_idmanager foreign key (idManager) references Manager(idManager),
    constraint unique_CNPJ_workshop UNIQUE (CNPJ)
);

CREATE TABLE ServiceOrder(
	idServiceOrder INT auto_increment NOT NULL,
    idCar INT NOT NULL,
    idClient INT NOT NULL,
    idWorkshop INT NOT NULL,
    entryDate DATE NOT NULL,
    expectedDepartureDate DATE,
    problemDescription VARCHAR(45),
    orderStatus ENUM('Aguardando', 'Em andamento', 'Concluído') DEFAULT 'Aguardando' NOT NULL,
    
    constraint pk_idServiceOrder primary key (idServiceOrder),
    constraint fk_serviceOrder_idcar foreign key (idCar) references Car(idCar),
    constraint fk_serviceOrder_idclient foreign key (idClient) references Clients(idClient),
    constraint fk_serviceOrder_idworkshop foreign key (idWorkshop) references Workshop(idWorkshop)
);

CREATE TABLE OrderPart(
	idPart INT NOT NULL,
    idServiceOrder INT NOT NULL,
    quantityUsed INT NOT NULL,
    
    primary key (idPart, idServiceOrder),
    constraint fk_orderPart_idpart foreign key (idPart) references Part(idPart),
    constraint fk_orderPart_idserviceOrder foreign key (idServiceOrder) references ServiceOrder(idServiceOrder)
);

CREATE TABLE ServiceOrderExecuted(
	idServiceOrder INT NOT NULL,
    idService INT NOT NULL,
    price DECIMAL(10,2),
    
    primary key(idServiceOrder, idService),
    constraint fk_SOE_idserviceOrder foreign key (idServiceOrder) references ServiceOrder(idServiceOrder),	
	constraint fk_SOE_idservice foreign key (idService) references Service(idService)
);

CREATE TABLE Employee(
	idEmployee INT auto_increment NOT NULL,
    idWorkshop INT NOT NULL,
    fname VARCHAR(20) NOT NULL,
    lname VARCHAR(30) NOT NULL,
    CPF CHAR(11) NOT NULL,
    specialty VARCHAR(45) NOT NULL,
    dateHiring DATE,
    
    constraint pk_idEmployee primary key (idEmployee),
    constraint fk_employee_idWorkshop foreign key (idWorkshop) references Workshop(idWorkshop),
    constraint unique_CPF_employee UNIQUE(CPF)
);

CREATE TABLE EmployeeOrder(
	idEmployee INT NOT NULL,
    idServiceOrder INT NOT NULL,
    
    primary key (idEmployee, idServiceOrder),
    constraint fk_employeeOrder_idemployee foreign key (idEmployee) references Employee(idEmployee),
    constraint fk_employeeOrder_idserviceOrder foreign key (idServiceOrder) references ServiceOrder(idServiceOrder)
);


INSERT INTO Manager (fname, lname, CPF, Bdate, startDate) 
	VALUES  ('Carlos', 'Silva', '11122233344', '1972-07-29', '2010-01-20'),
			('Ana', 'Oliveira', '55566677788', '1985-09-10', '2012-03-15');

INSERT INTO Clients (CPF, fname, minit, lname, phoneNumber) 
	VALUES  ('12345678901', 'Maria', 'S', 'Santos', '11987654321'),
			('98765432109', 'João', 'P', 'Pereira', '21912345678'),
			('45678912304', 'Pedro', 'A', 'Almeida', '19998877665');

INSERT INTO Part (partName, unitPrice, stockQuantity) 
	VALUES  ('Filtro de Óleo', 45.50, 150),
			('Pastilha de Freio (Par)', 120.00, 80),
			('Vela de Ignição (Unidade)', 25.00, 200),
			('Óleo Motor 5W30 (Litro)', 55.00, 300);

INSERT INTO Service (serviceName, serviceDescription, price) 
	VALUES  ('Troca de Óleo e Filtro', 'Substituição do óleo e filtro do motor', 100.00),
			('Troca de Pastilhas de Freio', 'Substituição das pastilhas dianteiras', 80.00),
			('Alinhamento e Balanceamento', 'Alinhar direção e balancear rodas', 120.00),
			('Diagnóstico Elétrico', 'Verificação do sistema elétrico', 150.00);

INSERT INTO Workshop (idManager, workshopName, CNPJ, location)
	VALUES  (1, 'Oficina Central', '12345678000199', 'Rua Principal, 112'),
			(2, 'Oficina Filial Sul', '87654321000155', 'Avenida Sul, 534');

INSERT INTO Employee (idWorkshop, fname, lname, CPF, specialty, dateHiring) 
	VALUES  (1, 'Miguel', 'Costa', '10101010101', 'Mecânico Geral', '2015-06-01'),
			(1, 'Sofia', 'Fernandes', '20202020202', 'Eletricista', '2018-09-10'),
			(2, 'Lucas', 'Martins', '30303030303', 'Especialista em Freios', '2020-02-25');

INSERT INTO Car (carPlate, idClient, carBrand, model, fabricationYear, color)
	VALUES  ('ABC1234', 1, 'Fiat', 'Uno', '2015', 'Branco'),
			('XYZ5678', 2, 'Volkswagen', 'Gol', '2018', 'Preto'),
			('QWE9012', 3, 'Toyota', 'Corolla', '2020', 'Prata'),
			('RTY3456', 1, 'Honda', 'Civic', '2019', 'Azul'); 

INSERT INTO ServiceOrder (idCar, idClient, idWorkshop, entryDate, expectedDepartureDate, problemDescription, orderStatus) 
	VALUES	(1, 1, 1, '2025-10-10', '2025-10-11', 'Barulho no freio', 'Concluído'),
			(2, 2, 2, '2025-10-20', '2025-10-22', 'Revisão geral, troca de óleo', 'Em andamento'),
			(4, 1, 1, '2025-10-22', '2025-10-23', 'Falha elétrica, luzes piscando', 'Aguardando');

INSERT INTO EmployeeOrder (idEmployee, idServiceOrder) 
	VALUES	(1, 1), 
			(3, 2), 
			(1, 3), 
			(2, 3); 

INSERT INTO ServiceOrderExecuted (idServiceOrder, idService, price) 
	VALUES	(1, 2, 80.00), 
			(2, 1, 100.00), 
			(2, 3, 110.00), 
			(3, 4, 150.00); 

INSERT INTO OrderPart (idPart, idServiceOrder, quantityUsed) 
	VALUES	(2, 1, 1),
			(1, 2, 1), 
			(4, 2, 4);    



desc clients; 
desc car;

Select concat(fname, ' ', lname) as complete_name, c.carBrand, c.model, c.carPlate 
	FROM Car as c
    JOIN Clients as cl ON c.idClient = cl.idClient
    ORDER BY complete_name;
 
 desc employee;
 desc workshop;
 
 Select e.idEmployee, concat(fname, ' ', lname) as complete_name, e.CPF, e.specialty
	FROM Employee as e
    JOIN Workshop as w ON e.idWorkshop = w.idWorkshop
    WHERE w.WorkshopName = 'Oficina Central';
 
select concat(fname, ' ', lname) as complete_name, COUNT(ca.idCar) as Number_cars
	FROM Clients as c
    JOIN Car as ca ON c.idClient = ca.idClient
    GROUP BY c.idClient;

show tables;    
desc Service;
desc serviceorder;
desc serviceorderexecuted;

select soe.idServiceOrder, group_concat(S.serviceName SEPARATOR ',') as serviceName, SUM(soe.price) as totalPriceServiceOrder
	FROM ServiceOrderExecuted as soe
    INNER JOIN Service as s ON soe.idService = s.idService
    GROUP BY soe.idServiceOrder;
    
select s.serviceName, soe.price 
	FROM Service as s 
	JOIN ServiceOrderExecuted as soe ON s.idService = soe.idService
    ORDER BY soe.price DESC;
    
desc manager;
desc workshop;

select concat(m.fname, ' ', m.lname) as managerName, m.startDate, w.workshopName, w.location, w.CNPJ
	From Manager as m
    JOIN workshop as w ON m.idManager = w.idManager;