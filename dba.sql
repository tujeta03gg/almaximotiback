USE master;
GO

-- Verificar si el LOGIN ya existe
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'rootAlmaximo')
BEGIN
    -- Crear el LOGIN
    CREATE LOGIN [rootAlmaximo] WITH PASSWORD = 'rootAlmaximo';
    -- Agregar el LOGIN al rol sysadmin
    ALTER SERVER ROLE [sysadmin] ADD MEMBER [rootAlmaximo];
END
ELSE
BEGIN
    PRINT 'The login "rootAlmaximo" already exists.';
END


-- Eliminar la base de datos si existe
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'almaximotiDB')
BEGIN
    DROP DATABASE almaximotiDB;
END;
GO

-- Crear la base de datos si no existe
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'almaximotiDB')
BEGIN
    CREATE DATABASE almaximotiDB;
END;
GO

-- Usar la base de datos
USE almaximotiDB;
GO

CREATE TABLE type(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Description VARCHAR(255),
    Name VARCHAR(50),
    Deleted TINYINT DEFAULT 0,
    CreateDate DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    UpdateDate DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Trigger para actualizar UpdateDate en type
CREATE TRIGGER trg_UpdateType
ON type
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE type
    SET UpdateDate = CURRENT_TIMESTAMP
    FROM type
    INNER JOIN inserted i ON type.ID = i.ID;
END;
GO

CREATE TABLE supplier(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Description VARCHAR(255),
    Name VARCHAR(50),
    Deleted TINYINT DEFAULT 0,
    CreateDate DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    UpdateDate DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Trigger para actualizar UpdateDate en supplier
CREATE TRIGGER trg_UpdateSupplier
ON supplier
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE supplier
    SET UpdateDate = CURRENT_TIMESTAMP
    FROM supplier
    INNER JOIN inserted i ON supplier.ID = i.ID;
END;
GO

CREATE TABLE product(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50),
    Price DECIMAL(19,4),
    ProductKey VARCHAR(50),
    TypeID INT,
    Deleted TINYINT DEFAULT 0,
    CreateDate DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    UpdateDate DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TypeID) REFERENCES type(ID)
);
GO

-- Trigger para actualizar UpdateDate en product
CREATE TRIGGER trg_UpdateProduct
ON product
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE product
    SET UpdateDate = CURRENT_TIMESTAMP
    FROM product
    INNER JOIN inserted i ON product.ID = i.ID;
END;
GO

CREATE TABLE productSupplier (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ProductId INT,
    SupplierId INT,
    SupplierProductKey VARCHAR(255),
    SupplierCost DECIMAL(10, 2),
    Deleted TINYINT DEFAULT 0,
    CreateDate DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    UpdateDate DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductId) REFERENCES product(ID),
    FOREIGN KEY (SupplierId) REFERENCES supplier(ID)
);
GO

CREATE TRIGGER trg_UpdateProductSupplier
ON productSupplier
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE productSupplier
    SET UpdateDate = CURRENT_TIMESTAMP
    FROM productSupplier
    INNER JOIN inserted i ON productSupplier.ID = i.ID;
END;
GO

-- Procedimiento almacenado para la tabla type
CREATE PROCEDURE GetAllTypes
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM type WHERE Deleted = 0;
END;
GO

-- Procedimiento almacenado para obtener un registro por ID en la tabla type
CREATE PROCEDURE GetTypeById
    @TypeId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM type
    WHERE ID = @TypeId AND Deleted = 0;
END;
GO

-- Procedimiento almacenado para crear un nuevo tipo en la tabla type
CREATE PROCEDURE CreateType
    @Description VARCHAR(255),
    @Name VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO type (Description, Name)
    VALUES (@Description, @Name);

    -- Opcional: Devolver el ID del nuevo registro insertado
    SELECT SCOPE_IDENTITY() AS NewTypeId;
END;
GO

-- Procedimiento almacenado para actualizar un tipo en la tabla type
CREATE PROCEDURE UpdateType
    @TypeId INT,
    @Description VARCHAR(255),
    @Name VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE type
    SET Description = @Description,
        Name = @Name
    WHERE ID = @TypeId;
END;
GO

-- Procedimiento almacenado para marcar como eliminado un tipo en la tabla type
CREATE PROCEDURE DeleteType
    @TypeId INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE type
    SET Deleted = 1
    WHERE ID = @TypeId;
END;
GO


-- Procedimiento almacenado para la tabla supplier
CREATE PROCEDURE GetAllSuppliers
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM supplier WHERE Deleted = 0;
END;
GO

-- Procedimiento almacenado para obtener un proveedor por ID en la tabla supplier
CREATE PROCEDURE GetSupplierById
    @SupplierId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM supplier
    WHERE ID = @SupplierId AND Deleted =0;
END;
GO

-- Procedimiento almacenado para crear un nuevo proveedor en la tabla supplier
CREATE PROCEDURE CreateSupplier
    @Description VARCHAR(255),
    @Name VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO supplier (Description, Name)
    VALUES (@Description, @Name);

    -- Opcional: Devolver el ID del nuevo registro insertado
    SELECT SCOPE_IDENTITY() AS NewSupplierId;
END;
GO

-- Procedimiento almacenado para actualizar un proveedor en la tabla supplier
CREATE PROCEDURE UpdateSupplier
    @SupplierId INT,
    @Description VARCHAR(255),
    @Name VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE supplier
    SET Description = @Description,
        Name = @Name
    WHERE ID = @SupplierId;
END;
GO

-- Procedimiento almacenado para marcar como eliminado un proveedor en la tabla supplier
CREATE PROCEDURE DeleteSupplier
    @SupplierId INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE supplier
    SET Deleted = 1
    WHERE ID = @SupplierId;
END;
GO


-- Procedimiento almacenado para la tabla product
CREATE PROCEDURE GetAllProducts
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  p.ID,
            p.Name,
            p.ProductKey,
            p.Deleted,
            p.Price,
            t.Name as TypeName
    FROM product p INNER JOIN type t ON p.TypeID = t.ID WHERE p.Deleted = 0;
END;
GO

-- Procedimiento almacenado para obtener un producto por ID en la tabla product
CREATE PROCEDURE GetProductById
    @ProductId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  p.ID,
            p.Name,
            p.ProductKey,
            p.Deleted,
            p.Price,
            t.Name as TypeName
    FROM product p INNER JOIN type t ON p.TypeID = t.ID WHERE p.ID = @ProductId AND p.Deleted = 0;
END;
GO

-- Procedimiento almacenado para obtener los supplier de un product
CREATE PROCEDURE GetSuppliersProduct
    @ProductId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  ps.ID,
            ps.ProductId,
            ps.SupplierProductKey,
            ps.SupplierCost,
            s.Name
    FROM productSupplier ps INNER JOIN supplier s ON ps.SupplierId = s.ID
    WHERE ps.ProductId = @ProductId AND ps.Deleted = 0
END;
GO

-- Procedimiento almacenado para crear un nuevo product y productSupplier
CREATE PROCEDURE CreateProduct
    @Name VARCHAR(50),
    @Price DECIMAL(19,4),
    @ProductKey VARCHAR(50),
    @TypeID INT,
    @SupplierID INT,
    @SupplierProductKey VARCHAR(50),
    @SupplierCost DECIMAL(19,4)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO product (Name, Price, ProductKey, TypeID, CreateDate, UpdateDate)
        VALUES (@Name, @Price, @ProductKey, @TypeID, GETDATE(), GETDATE());

        DECLARE @last_id INT;
        SET @last_id = SCOPE_IDENTITY();

        INSERT INTO productSupplier (ProductId, SupplierId, SupplierProductKey, SupplierCost, CreateDate, UpdateDate)
        VALUES (@last_id, @SupplierID, @SupplierProductKey, @SupplierCost, GETDATE(), GETDATE());

        -- Devolver el ID del producto insertado
        SELECT @last_id AS NewProductId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
        THROW;
    END CATCH;
END;
GO
-- Procedimiento almacenado para actualizar product
CREATE PROCEDURE UpdateProduct
    @Name VARCHAR(50),
    @ProductKey VARCHAR(50),
    @Price DECIMAL(19,4),
    @TypeID INT,
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE product SET name = @Name, ProductKey = @ProductKey, Price = @Price, TypeID = @TypeID WHERE ID = @ID;

        -- Devolver el ID del producto actualizado
        SELECT @ID AS ProductId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SELECT 0,ERROR_MESSAGE() AS ErrorMessage;
        THROW;
    END CATCH;
END;
GO

-- Procedimiento almacenado para eliminar product
CREATE PROCEDURE DeleteProduct
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE product SET Deleted = 1 WHERE ID = @ID;

        -- Devolver el ID del producto actualizado
        SELECT @ID AS ProductId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SELECT 0,ERROR_MESSAGE() AS ErrorMessage;
        THROW;
    END CATCH;
END;
GO

-- Procedimiento almacenado para eliminar product
CREATE PROCEDURE DeleteProductSupplier
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE productSupplier SET Deleted = 1 WHERE ID = @ID;

        -- Devolver el ID del producto actualizado
        SELECT @ID AS ProductId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SELECT 0,ERROR_MESSAGE() AS ErrorMessage;
        THROW;
    END CATCH;
END;
GO

-- Procedimiento almacenado para la tabla productSupplier
CREATE PROCEDURE GetAllProductSuppliers
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM productSupplier WHERE Deleted = 0;
END;
GO
CREATE PROCEDURE GetProductSupplierById
    @ProductSupplerID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
    ps.ID,
    s.ID as supplierID,
    s.Name,
    ps.SupplierProductKey,
    ps.SupplierCost
    FROM productSupplier ps
    LEFT JOIN supplier s ON s.id = ps.SupplierId
    WHERE ps.ID = @ProductSupplerID AND ps.Deleted = 0;
END;
GO
-- Procedimiento almacenado para obtener un producto proveedor por ID en la tabla productSupplier
CREATE PROCEDURE GetProductSupplierByProduct
    @ProductId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT s.Name,
           ps.SupplierProductKey,
           ps.SupplierCost,
           s.ID as supplierId,
           ps.ID
    FROM productSupplier ps
    INNER JOIN supplier s ON s.ID = ps.SupplierId
    WHERE ps.ProductId = @ProductId AND ps.Deleted = 0;
END;
GO
-- Procedimiento almacenado para actualizar product
CREATE PROCEDURE UpdateProductSupplier
    @SupplierID INT,
    @SupplierProductKey VARCHAR(50),
    @SupplierCost DECIMAL(19,4),
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE productSupplier SET SupplierId = @SupplierID, SupplierProductKey = @SupplierProductKey, SupplierCost = @SupplierCost WHERE ID = @ID;

        -- Devolver el ID del producto actualizado
        SELECT @ID AS ProductSuplierId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SELECT 0,ERROR_MESSAGE() AS ErrorMessage;
        THROW;
    END CATCH;
END;
GO


-- inserts default for typpe
EXEC CreateType @Description = 'Descripcion Electronica',@Name = 'Electronica';
EXEC CreateType @Description = 'Descripcion Hogar y Cocina',@Name = 'Hogar y Cocina';
EXEC CreateType @Description = 'Descripcion Libors',@Name = 'Libros';
EXEC CreateType @Description = 'Descripcion Ropa',@Name = 'Ropa';
EXEC CreateType @Description = 'Descripcion Ropa',@Name = 'Accesorios';
GO

EXEC CreateSupplier @Description = 'Descripcion Samsung', @Name = 'Samsung';
EXEC CreateSupplier @Description = 'Descripcion Apple', @Name = 'Apple';
EXEC CreateSupplier @Description = 'Descripcion Logitech', @Name = 'Logitech';

EXEC CreateSupplier @Description = 'Descripcion Editorial Planeta', @Name = 'Editorial Planeta';
EXEC CreateSupplier @Description = 'Descripcion Editorial Penguin Random House', @Name = 'Editorial Penguin Random House';
EXEC CreateSupplier @Description = 'Descripcion Editorial Anagrama', @Name = 'Editorial Anagrama';

EXEC CreateSupplier @Description = 'Descripcion Levis', @Name = 'Levis';
EXEC CreateSupplier @Description = 'Descripcion H&M', @Name = 'H&M';
EXEC CreateSupplier @Description = 'Descripcion Zara', @Name = 'Zara';

-- INSERTS PRODUCT
-- ELECTRONICOS
EXEC CreateProduct
@Name = 'Monitor IPS 27"',
@Price = 3999.99,
@ProductKey = 'MIPS-27500',
@TypeID = 1,
@SupplierID =  1,
@SupplierProductKey = 'A3B7K9',
@SupplierCost = 2999.99;

EXEC CreateProduct
@Name = 'Monitor VA Curvo 24"',
@Price = 5000.00,
@ProductKey = 'MVA-24600',
@TypeID = 1,
@SupplierID = 1,
@SupplierProductKey ='A3B7K8',
@SupplierCost = 2500.00;

EXEC CreateProduct
@Name = 'Monitor IPS 24"',
@Price = 4500.00,
@ProductKey = 'MIPS-24500',
@TypeID = 1,
@SupplierID = 1,
@SupplierProductKey = 'A3B7K7',
@SupplierCost = 3700.00;

EXEC CreateProduct
@Name = 'Monitor VA Curvo 27"',
@Price = 6499.99,
@ProductKey = 'MVA-27600',
@TypeID = 1,
@SupplierID = 1,
@SupplierProductKey = 'A3B7K6',
@SupplierCost = 4000.99;

EXEC CreateProduct
@Name = 'Mackbook Air M1 ',
@Price = 13000.00,
@ProductKey = 'MBA-00M1',
@TypeID = 1,
@SupplierID = 2,
@SupplierProductKey = 'C5E2M1',
@SupplierCost = 9000.00;

EXEC CreateProduct
@Name = 'Mackbook Pro M1 ',
@Price = 23000.00,
@ProductKey = 'MBP-00M1',
@TypeID = 1,
@SupplierID = 2,
@SupplierProductKey = 'C6E2M1',
@SupplierCost = 19000.00;

EXEC CreateProduct
@Name = 'Mac Mini M1 ',
@Price = 10000.00,
@ProductKey = 'MMM-00M1',
@TypeID = 1,
@SupplierID = 2,
@SupplierProductKey = 'C4E2M1',
@SupplierCost = 7000.00;

EXEC CreateProduct
@Name = 'Mouse Ergonomico',
@Price = 1999.50,
@ProductKey = 'G501',
@TypeID = 1,
@SupplierID = 3,
@SupplierProductKey = 'P9Q6R3',
@SupplierCost = 500.00;

EXEC CreateProduct
@Name = 'Webcam Pro',
@Price = 4000.00,
@ProductKey = 'GWB1000',
@TypeID = 1,
@SupplierID = 3,
@SupplierProductKey = 'P9Q6R2',
@SupplierCost = 2500.00;

--Libros

EXEC CreateProduct
    @Name = 'Cien años de soledad',
    @Price = 150.00,
    @ProductKey = 'LIB1001',
    @TypeID = 3,
    @SupplierID = 4,
    @SupplierProductKey = 'FIC001',
    @SupplierCost = 100.00;

EXEC CreateProduct
    @Name = 'El señor de los anillos: La comunidad del anillo',
    @Price = 180.00,
    @ProductKey = 'LIB1002',
    @TypeID = 3,
    @SupplierID = 4,
    @SupplierProductKey = 'FIC002',
    @SupplierCost = 120.00;

EXEC CreateProduct
    @Name = 'Breve historia del tiempo',
    @Price = 120.00,
    @ProductKey = 'LIB1003',
    @TypeID = 3,
    @SupplierID = 5,
    @SupplierProductKey = 'NFIC001',
    @SupplierCost = 80.00;

EXEC CreateProduct
    @Name = 'Sapiens: De animales a dioses',
    @Price = 140.00,
    @ProductKey = 'LIB1004',
    @TypeID = 3,
    @SupplierID = 6,
    @SupplierProductKey = 'NFIC002',
    @SupplierCost = 90.00;

EXEC CreateProduct
    @Name = '1984',
    @Price = 110.00,
    @ProductKey = 'LIB1005',
    @TypeID = 3,
    @SupplierID = 6,
    @SupplierProductKey = 'FIC003',
    @SupplierCost = 70.00;

EXEC CreateProduct
    @Name = 'Crimen y castigo',
    @Price = 130.00,
    @ProductKey = 'LIB1006',
    @TypeID = 3,
    @SupplierID = 6,
    @SupplierProductKey = 'FIC004',
    @SupplierCost = 85.00;
GO
--Ropa
-- Prendas para Hombres
EXEC CreateProduct
    @Name = 'Camisa de Vestir Negra',
    @Price = 80.00,
    @ProductKey = 'ROP1001',
    @TypeID = 4,
    @SupplierID = 7,
    @SupplierProductKey = 'HOM001',
    @SupplierCost = 50.00;

EXEC CreateProduct
    @Name = 'Pantalones de Mezclilla Azules',
    @Price = 60.00,
    @ProductKey = 'ROP1002',
    @TypeID = 4,
    @SupplierID = 7,
    @SupplierProductKey = 'HOM002',
    @SupplierCost = 40.00;

EXEC CreateProduct
    @Name = 'Chaqueta de Cuero Marrón',
    @Price = 120.00,
    @ProductKey = 'ROP1003',
    @TypeID = 4,
    @SupplierID = 7,
    @SupplierProductKey = 'HOM003',
    @SupplierCost = 90.00;

EXEC CreateProduct
    @Name = 'Zapatos Formales Negros',
    @Price = 100.00,
    @ProductKey = 'ROP1004',
    @TypeID = 4,
    @SupplierID = 8,
    @SupplierProductKey = 'HOM004',
    @SupplierCost = 70.00;

-- Prendas para Mujeres
EXEC CreateProduct
    @Name = 'Vestido de Noche Rojo',
    @Price = 150.00,
    @ProductKey = 'ROP1005',
    @TypeID = 4,
    @SupplierID = 8,
    @SupplierProductKey = 'WOM001',
    @SupplierCost = 100.00;

EXEC CreateProduct
    @Name = 'Falda Lápiz Negra',
    @Price = 70.00,
    @ProductKey = 'ROP1006',
    @TypeID = 4,
    @SupplierID = 7,
    @SupplierProductKey = 'WOM002',
    @SupplierCost = 45.00;

EXEC CreateProduct
    @Name = 'Blusa Floral',
    @Price = 50.00,
    @ProductKey = 'ROP1007',
    @TypeID = 4,
    @SupplierID = 8,
    @SupplierProductKey = 'WOM003',
    @SupplierCost = 30.00;
GO

INSERT INTO productSupplier(ProductId, SupplierId, SupplierProductKey, SupplierCost)
VALUES
    (1,2,'JKHGSDF',3000.00),
    (1,3,'SDFKJBH',2500.00);
GO
INSERT INTO productSupplier(ProductId, SupplierId, SupplierProductKey, SupplierCost)
VALUES
    (2,2,'JKHGSDF',2000.00),
    (2,3,'SDFKJBH',2300.00);
GO
INSERT INTO productSupplier(ProductId, SupplierId, SupplierProductKey, SupplierCost)
VALUES
    (3,2,'JKHGSDF',3800.00),
    (3,3,'SDFKJBH',4000.00);
GO
INSERT INTO productSupplier(ProductId, SupplierId, SupplierProductKey, SupplierCost)
VALUES
    (4,2,'JKHGSDF',3600.00),
    (4,3,'SDFKJBH',4200.00);
GO
