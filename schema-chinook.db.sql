# Chinook Database for Udacity project
# Script for Chinook Database Schema creation
# Adapted to use with MySQL by Renan Critelli

DROP DATABASE IF EXISTS Chinook;
CREATE DATABASE IF NOT EXISTS Chinook; 
USE Chinook;

DROP TABLE IF EXISTS `Artist`;
CREATE TABLE IF NOT EXISTS `Artist` (
	`ArtistId`	INTEGER NOT NULL,
	`Name`	VARCHAR ( 120 ),
	CONSTRAINT `PK_Artist` PRIMARY KEY(`ArtistId`)
);

DROP TABLE IF EXISTS `Album`;
CREATE TABLE IF NOT EXISTS `Album` (
	`AlbumId`	INTEGER NOT NULL,
	`Title`	VARCHAR ( 160 ) NOT NULL,
	`ArtistId`	INTEGER NOT NULL,
	CONSTRAINT `PK_Album` PRIMARY KEY(`AlbumId`),
	FOREIGN KEY(`ArtistId`) REFERENCES `Artist`(`ArtistId`) ON DELETE NO ACTION ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS `MediaType`;
CREATE TABLE IF NOT EXISTS `MediaType` (
	`MediaTypeId`	INTEGER NOT NULL,
	`Name`	VARCHAR ( 120 ),
	CONSTRAINT `PK_MediaType` PRIMARY KEY(`MediaTypeId`)
);

DROP TABLE IF EXISTS `Genre`;
CREATE TABLE IF NOT EXISTS `Genre` (
	`GenreId`	INTEGER NOT NULL,
	`Name`	VARCHAR ( 120 ),
	CONSTRAINT `PK_Genre` PRIMARY KEY(`GenreId`)
);

DROP TABLE IF EXISTS `Track`;
CREATE TABLE IF NOT EXISTS `Track` (
	`TrackId`	INTEGER NOT NULL,
	`Name`	VARCHAR ( 200 ) NOT NULL,
	`AlbumId`	INTEGER,
	`MediaTypeId`	INTEGER NOT NULL,
	`GenreId`	INTEGER,
	`Composer`	VARCHAR ( 220 ),
	`Milliseconds`	INTEGER NOT NULL,
	`Bytes`	INTEGER,
	`UnitPrice`	NUMERIC ( 10 , 2 ) NOT NULL,
	FOREIGN KEY(`AlbumId`) REFERENCES `Album`(`AlbumId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	FOREIGN KEY(`MediaTypeId`) REFERENCES `MediaType`(`MediaTypeId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `PK_Track` PRIMARY KEY(`TrackId`),
	FOREIGN KEY(`GenreId`) REFERENCES `Genre`(`GenreId`) ON DELETE NO ACTION ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS `Playlist`;
CREATE TABLE IF NOT EXISTS `Playlist` (
	`PlaylistId`	INTEGER NOT NULL,
	`Name`	VARCHAR ( 120 ),
	CONSTRAINT `PK_Playlist` PRIMARY KEY(`PlaylistId`)
);

DROP TABLE IF EXISTS `PlaylistTrack`;
CREATE TABLE IF NOT EXISTS `PlaylistTrack` (
	`PlaylistId`	INTEGER NOT NULL,
	`TrackId`	INTEGER NOT NULL,
	FOREIGN KEY(`PlaylistId`) REFERENCES `Playlist`(`PlaylistId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	FOREIGN KEY(`TrackId`) REFERENCES `Track`(`TrackId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `PK_PlaylistTrack` PRIMARY KEY(`PlaylistId`,`TrackId`)
);

DROP TABLE IF EXISTS `Employee`;
CREATE TABLE IF NOT EXISTS `Employee` (
	`EmployeeId`	INTEGER NOT NULL,
	`LastName`	VARCHAR ( 20 ) NOT NULL,
	`FirstName`	VARCHAR ( 20 ) NOT NULL,
	`Title`	VARCHAR ( 30 ),
	`ReportsTo`	INTEGER,
	`BirthDate`	DATETIME,
	`HireDate`	DATETIME,
	`Address`	VARCHAR ( 70 ),
	`City`	VARCHAR ( 40 ),
	`State`	VARCHAR ( 40 ),
	`Country`	VARCHAR ( 40 ),
	`PostalCode`	VARCHAR ( 10 ),
	`Phone`	VARCHAR ( 24 ),
	`Fax`	VARCHAR ( 24 ),
	`Email`	VARCHAR ( 60 ),
	FOREIGN KEY(`ReportsTo`) REFERENCES `Employee`(`EmployeeId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `PK_Employee` PRIMARY KEY(`EmployeeId`)
);

DROP TABLE IF EXISTS `Customer`;
CREATE TABLE IF NOT EXISTS `Customer` (
	`CustomerId`	INTEGER NOT NULL,
	`FirstName`	VARCHAR ( 40 ) NOT NULL,
	`LastName`	VARCHAR ( 20 ) NOT NULL,
	`Company`	VARCHAR ( 80 ),
	`Address`	VARCHAR ( 70 ),
	`City`	VARCHAR ( 40 ),
	`State`	VARCHAR ( 40 ),
	`Country`	VARCHAR ( 40 ),
	`PostalCode`	VARCHAR ( 10 ),
	`Phone`	VARCHAR ( 24 ),
	`Fax`	VARCHAR ( 24 ),
	`Email`	VARCHAR ( 60 ) NOT NULL,
	`SupportRepId`	INTEGER,
	CONSTRAINT `PK_Customer` PRIMARY KEY(`CustomerId`),
	FOREIGN KEY(`SupportRepId`) REFERENCES `Employee`(`EmployeeId`) ON DELETE NO ACTION ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS `Invoice`;
CREATE TABLE IF NOT EXISTS `Invoice` (
	`InvoiceId`	INTEGER NOT NULL,
	`CustomerId`	INTEGER NOT NULL,
	`InvoiceDate`	DATETIME NOT NULL,
	`BillingAddress`	VARCHAR ( 70 ),
	`BillingCity`	VARCHAR ( 40 ),
	`BillingState`	VARCHAR ( 40 ),
	`BillingCountry`	VARCHAR ( 40 ),
	`BillingPostalCode`	VARCHAR ( 10 ),
	`Total`	NUMERIC ( 10 , 2 ) NOT NULL,
	FOREIGN KEY(`CustomerId`) REFERENCES `Customer`(`CustomerId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `PK_Invoice` PRIMARY KEY(`InvoiceId`)
);

DROP TABLE IF EXISTS `InvoiceLine`;
CREATE TABLE IF NOT EXISTS `InvoiceLine` (
	`InvoiceLineId`	INTEGER NOT NULL,
	`InvoiceId`	INTEGER NOT NULL,
	`TrackId`	INTEGER NOT NULL,
	`UnitPrice`	NUMERIC ( 10 , 2 ) NOT NULL,
	`Quantity`	INTEGER NOT NULL,
	FOREIGN KEY(`InvoiceId`) REFERENCES `Invoice`(`InvoiceId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	FOREIGN KEY(`TrackId`) REFERENCES `Track`(`TrackId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `PK_InvoiceLine` PRIMARY KEY(`InvoiceLineId`)
);


# ATTENTION!!!
# The following will NOT check for already existing indexes

CREATE UNIQUE INDEX `IPK_Track` ON `Track` (
	`TrackId`
);

CREATE UNIQUE INDEX `IPK_PlaylistTrack` ON `PlaylistTrack` (
	`PlaylistId`,
	`TrackId`
);

CREATE UNIQUE INDEX `IPK_Playlist` ON `Playlist` (
	`PlaylistId`
);

CREATE UNIQUE INDEX `IPK_MediaType` ON `MediaType` (
	`MediaTypeId`
);

CREATE UNIQUE INDEX  `IPK_InvoiceLine` ON `InvoiceLine` (
	`InvoiceLineId`
);

CREATE UNIQUE INDEX  `IPK_Invoice` ON `Invoice` (
	`InvoiceId`
);

CREATE UNIQUE INDEX  `IPK_Genre` ON `Genre` (
	`GenreId`
);

CREATE UNIQUE INDEX `IPK_Employee` ON `Employee` (
	`EmployeeId`
);

CREATE UNIQUE INDEX `IPK_Customer` ON `Customer` (
	`CustomerId`
);

CREATE UNIQUE INDEX `IPK_Artist` ON `Artist` (
	`ArtistId`
);

CREATE UNIQUE INDEX  `IPK_Album` ON `Album` (
	`AlbumId`
);

CREATE INDEX `IFK_TrackMediaTypeId` ON `Track` (
	`MediaTypeId`
);

CREATE INDEX `IFK_TrackGenreId` ON `Track` (
	`GenreId`
);

CREATE INDEX  `IFK_TrackAlbumId` ON `Track` (
	`AlbumId`
);

CREATE INDEX `IFK_PlaylistTrackTrackId` ON `PlaylistTrack` (
	`TrackId`
);

CREATE INDEX `IFK_InvoiceLineTrackId` ON `InvoiceLine` (
	`TrackId`
);

CREATE INDEX  `IFK_InvoiceLineInvoiceId` ON `InvoiceLine` (
	`InvoiceId`
);

CREATE INDEX `IFK_InvoiceCustomerId` ON `Invoice` (
	`CustomerId`
);

CREATE INDEX `IFK_EmployeeReportsTo` ON `Employee` (
	`ReportsTo`
);

CREATE INDEX `IFK_CustomerSupportRepId` ON `Customer` (
	`SupportRepId`
);

CREATE INDEX `IFK_AlbumArtistId` ON `Album` (
	`ArtistId`
);
COMMIT;
