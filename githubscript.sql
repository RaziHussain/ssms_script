USE [master]
GO
/****** Object:  Database [ODC_PMS_Auth]    Script Date: 01-11-2023 16:48:12 ******/
CREATE DATABASE [ODC_PMS_Auth]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ODC_PMS_Auth', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\ODC_PMS_Auth.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ODC_PMS_Auth_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\ODC_PMS_Auth_log.ldf' , SIZE = 3904KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ODC_PMS_Auth] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ODC_PMS_Auth].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ODC_PMS_Auth] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET ARITHABORT OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ODC_PMS_Auth] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ODC_PMS_Auth] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ODC_PMS_Auth] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ODC_PMS_Auth] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET RECOVERY FULL 
GO
ALTER DATABASE [ODC_PMS_Auth] SET  MULTI_USER 
GO
ALTER DATABASE [ODC_PMS_Auth] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ODC_PMS_Auth] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ODC_PMS_Auth] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ODC_PMS_Auth] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [ODC_PMS_Auth]
GO
/****** Object:  Schema [UserManagement]    Script Date: 01-11-2023 16:48:13 ******/
CREATE SCHEMA [UserManagement]
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Split](@String nvarchar(4000), @Delimiter char(1))
RETURNS @Results TABLE (id int identity(1,1), Items nvarchar(4000))
AS
BEGIN
DECLARE @INDEX INT
DECLARE @SLICE nvarchar(4000)
-- HAVE TO SET TO 1 SO IT DOESNT EQUAL Z
--     ERO FIRST TIME IN LOOP
SELECT @INDEX = 1
WHILE @INDEX !=0
BEGIN
-- GET THE INDEX OF THE FIRST OCCURENCE OF THE SPLIT CHARACTER
SELECT @INDEX = CHARINDEX(@Delimiter,@STRING)
-- NOW PUSH EVERYTHING TO THE LEFT OF IT INTO THE SLICE VARIABLE
IF @INDEX !=0
SELECT @SLICE = LEFT(@STRING,@INDEX - 1)
ELSE
SELECT @SLICE = @STRING
-- PUT THE ITEM INTO THE RESULTS SET
INSERT INTO @Results(Items) VALUES(@SLICE)
-- CHOP THE ITEM REMOVED OFF THE MAIN STRING
SELECT @STRING = RIGHT(@STRING,LEN(@STRING) - @INDEX)
-- BREAK OUT IF WE ARE DONE
IF LEN(@STRING) = 0 BREAK
END
RETURN
END





GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[SplitString]
(    
      @Input NVARCHAR(MAX),
      @Character CHAR(1)
)
RETURNS @Output TABLE (
      Item NVARCHAR(1000)
)
AS
BEGIN
      DECLARE @StartIndex INT, @EndIndex INT
 
      SET @StartIndex = 1
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
      BEGIN
            SET @Input = @Input + @Character
      END
 
      WHILE CHARINDEX(@Character, @Input) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@Character, @Input)
           
            INSERT INTO @Output(Item)
            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
           
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
      END
 
      RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[udfGetNamebyUserLoginId]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udfGetNamebyUserLoginId](@UserLoginId BigInt)
RETURNS NVARCHAR (256)

AS
BEGIN
	DECLARE @Name NVARCHAR(256)
	SELECT @Name = Name
	FROm tblUserLogin
	WHERE UserLoginId=@UserLoginId

	RETURN ISNULL(@Name,'')
END






GO
/****** Object:  UserDefinedFunction [dbo].[udfGetUserNameNamebyUserLoginId]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udfGetUserNameNamebyUserLoginId](@UserLoginId BigInt)
RETURNS NVARCHAR (256)

AS
BEGIN
	DECLARE @UserName NVARCHAR(256)
	SELECT @UserName = UserName
	FROm tblUserLogin
	WHERE UserLoginId=@UserLoginId

	RETURN ISNULL(@UserName,'')
END




GO
/****** Object:  UserDefinedFunction [dbo].[udfTableValuedSplit]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create FUNCTION [dbo].[udfTableValuedSplit](@String nvarchar(4000), @Delimiter char(1))
RETURNS @Results TABLE (id int identity(1,1), Items nvarchar(4000))
AS
BEGIN
DECLARE @INDEX INT
DECLARE @SLICE nvarchar(4000)
-- HAVE TO SET TO 1 SO IT DOESNT EQUAL Z
--     ERO FIRST TIME IN LOOP
SELECT @INDEX = 1
WHILE @INDEX !=0
BEGIN
-- GET THE INDEX OF THE FIRST OCCURENCE OF THE SPLIT CHARACTER
SELECT @INDEX = CHARINDEX(@Delimiter,@STRING)
-- NOW PUSH EVERYTHING TO THE LEFT OF IT INTO THE SLICE VARIABLE
IF @INDEX !=0
SELECT @SLICE = LEFT(@STRING,@INDEX - 1)
ELSE
SELECT @SLICE = @STRING
-- PUT THE ITEM INTO THE RESULTS SET
INSERT INTO @Results(Items) VALUES(@SLICE)
-- CHOP THE ITEM REMOVED OFF THE MAIN STRING
SELECT @STRING = RIGHT(@STRING,LEN(@STRING) - @INDEX)
-- BREAK OUT IF WE ARE DONE
IF LEN(@STRING) = 0 BREAK
END
RETURN
END







GO
/****** Object:  Table [dbo].[AppUserSingInUpRequest]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppUserSingInUpRequest](
	[RequestId] [uniqueidentifier] NOT NULL,
	[Email] [varchar](128) NOT NULL,
	[EmailVerificationOTP] [varchar](128) NULL,
	[EnailVerificationOTPSalt] [uniqueidentifier] NULL,
	[OTPValidTill] [datetime] NULL,
	[RequestedOn] [datetime] NULL,
 CONSTRAINT [PK_AppUserRegistrationRequest] PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [uniqueidentifier] NOT NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[Name] [nvarchar](256) NULL,
	[NormalizedName] [nvarchar](256) NULL,
	[Description] [nvarchar](max) NULL,
	[RoleType] [tinyint] NOT NULL,
	[IsPrimary] [bit] NOT NULL,
	[IsEditable] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsAdminRole] [bit] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[UpdatedBy] [uniqueidentifier] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[RoleName] [nvarchar](256) NULL,
	[IsActive] [bit] NULL,
	[SortOrder] [int] NULL,
 CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUser2FAEnabledSignIn]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUser2FAEnabledSignIn](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[AspNetUserId] [uniqueidentifier] NOT NULL,
	[RequestKey] [uniqueidentifier] NOT NULL,
	[RefreshKey] [nvarchar](500) NOT NULL,
	[VerificationOTP] [varchar](128) NULL,
	[VerificationOTPSalt] [uniqueidentifier] NULL,
	[OTPValidTill] [datetime] NULL,
	[RequestedOn] [datetime] NULL,
 CONSTRAINT [PK_AspNetUser2FAEnabledSignIn] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserProfile]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserProfile](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[UserImage] [varchar](max) NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[UpdatedBy] [uniqueidentifier] NULL,
	[Birthday] [nvarchar](128) NULL,
	[CoverImage] [nvarchar](256) NULL,
	[WebsiteUrl] [nvarchar](256) NULL,
	[InstagramUrl] [nvarchar](256) NULL,
	[TwitterUrl] [nvarchar](256) NULL,
	[YoutubeUrl] [nvarchar](256) NULL,
	[FacebookUrl] [nvarchar](256) NULL,
 CONSTRAINT [PK_AspNetUserProfile_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRejection]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRejection](
	[Id] [uniqueidentifier] NOT NULL,
	[EnterpriseFkId] [uniqueidentifier] NOT NULL,
	[AspNetUserFkId] [uniqueidentifier] NOT NULL,
	[Reason] [nvarchar](4000) NULL,
	[RejectedBy] [uniqueidentifier] NULL,
	[RejectedOn] [datetime] NULL,
 CONSTRAINT [PK_AspNetUserRejection] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [uniqueidentifier] NOT NULL,
	[UserType] [tinyint] NOT NULL,
	[AccessFailedCount] [int] NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[FullName] [nvarchar](64) NULL,
	[UserName] [nvarchar](256) NULL,
	[FirstName] [nvarchar](128) NULL,
	[LastName] [nvarchar](128) NULL,
	[Email] [nvarchar](256) NOT NULL,
	[EmailConfirmed] [bit] NULL,
	[LockoutEnabled] [bit] NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[PhoneNumber] [varchar](256) NULL,
	[PhoneNumberConfirmed] [bit] NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[TwoFactorEnabled] [bit] NULL,
	[CountryCode] [nvarchar](16) NULL,
	[UserStatus] [tinyint] NOT NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[UpdatedBy] [uniqueidentifier] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsersDetail]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsersDetail](
	[Id] [uniqueidentifier] NOT NULL,
	[AspNetUsersFkId] [uniqueidentifier] NOT NULL,
	[DeviceTypeFkId] [int] NULL,
	[CryptoWalletAddress] [varchar](64) NULL,
	[LastLoggedIn] [datetime] NULL,
	[DefaultPasswordChanged] [bit] NOT NULL,
	[ForceChangePassword] [bit] NULL,
	[LastChangePasswordDate] [datetime] NULL,
	[WalletBalance] [decimal](30, 2) NULL,
	[ProfilePicture] [nvarchar](256) NULL,
	[DOB] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[UpdatedBy] [uniqueidentifier] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_AspNetUserInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsersEmailMobileVerification]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsersEmailMobileVerification](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[AspNetUsersFkId] [uniqueidentifier] NULL,
	[VerificationForFkId] [tinyint] NULL,
	[VerificationCode] [varchar](128) NULL,
	[VerficationOtp] [varchar](12) NULL,
	[RequestedOn] [datetime] NULL,
	[VerifiedOn] [datetime] NULL,
 CONSTRAINT [PK_AspNetUsersEmailMobileVerification] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserSetPassword]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserSetPassword](
	[Id] [uniqueidentifier] NOT NULL,
	[AspNetUserFkId] [uniqueidentifier] NULL,
	[OneTimeLink] [nvarchar](500) NULL,
	[IsExpire] [bit] NULL,
	[ExpireDateTime] [datetime] NULL,
	[CreatedDateTime] [datetime] NULL,
 CONSTRAINT [PK_AspNetUserSetPassword] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsersStatus]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsersStatus](
	[Id] [tinyint] IDENTITY(0,1) NOT NULL,
	[UserStatus] [varchar](64) NULL,
 CONSTRAINT [PK_AspNetUsersStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsersTypes]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsersTypes](
	[Id] [tinyint] IDENTITY(1,1) NOT NULL,
	[UserType] [varchar](64) NULL,
 CONSTRAINT [PK_AspNetUsersTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsersVerificationTypes]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsersVerificationTypes](
	[Id] [tinyint] IDENTITY(1,1) NOT NULL,
	[VerificationFor] [varchar](16) NULL,
 CONSTRAINT [PK_AspNetUsersVerificationTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Branch]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Branch](
	[BranchId] [bigint] IDENTITY(1,1) NOT NULL,
	[BranchName] [nvarchar](128) NULL,
	[Com_Code_Fk_Id] [int] NULL,
	[Status] [int] NULL,
	[CDatetime] [datetime] NULL,
 CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[BranchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DefaultSqlDataTypes]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DefaultSqlDataTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DefaultSqlDataTypes] [nvarchar](512) NULL,
	[DisplayNames] [nvarchar](1024) NULL,
 CONSTRAINT [PK_DefaultSqlDataTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DummyPieChartData]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DummyPieChartData](
	[Category] [varchar](50) NULL,
	[Value] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EMPLOYEES]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMPLOYEES](
	[COMP_CODE] [decimal](3, 0) NOT NULL,
	[EMPNO] [int] NOT NULL,
	[ENAME] [nvarchar](30) NULL,
	[DEPT] [nvarchar](30) NULL,
	[DIV] [nvarchar](30) NULL,
	[SEC] [nvarchar](30) NULL,
	[SALESM] [int] NULL,
	[SALESS] [int] NULL,
	[SALESC] [int] NULL,
	[HOME] [nvarchar](15) NULL,
	[MOBILE] [nvarchar](15) NULL,
	[DIRECT] [nvarchar](15) NULL,
	[FAX] [nvarchar](15) NULL,
	[EXT] [nvarchar](15) NULL,
	[EMAIL] [nvarchar](50) NULL,
	[SHIFT] [nvarchar](30) NULL,
	[ACTIVE] [int] NULL,
	[JDATE] [datetime] NULL,
	[BDATE] [datetime] NULL,
	[PASEXP] [datetime] NULL,
	[RESEXP] [datetime] NULL,
	[NAT] [nvarchar](20) NULL,
	[STATUS] [nvarchar](1) NULL,
	[EINI] [nvarchar](20) NULL,
	[SGROUP] [nvarchar](255) NULL,
	[FRIDAYFULL] [int] NULL,
	[SEX] [nvarchar](1) NULL,
	[RELIGION] [nvarchar](20) NULL,
	[MSTATUS] [nvarchar](10) NULL,
	[EDUC] [nvarchar](20) NULL,
	[TITLE] [nvarchar](30) NULL,
	[ID] [nvarchar](15) NULL,
	[WORKHOURS] [int] NULL,
	[SAT] [float] NULL,
	[SUN] [float] NULL,
	[MON] [float] NULL,
	[TUE] [float] NULL,
	[WED] [float] NULL,
	[THU] [float] NULL,
	[FRI] [float] NULL,
	[BOSS1] [nvarchar](20) NULL,
	[BOSS2] [nvarchar](20) NULL,
	[BOSS3] [nvarchar](20) NULL,
	[BOSS4] [nvarchar](20) NULL,
	[BOSS5] [nvarchar](20) NULL,
	[BOSS6] [nvarchar](20) NULL,
	[BOSS7] [nvarchar](20) NULL,
	[BOSS8] [nvarchar](20) NULL,
	[COMPANY] [nvarchar](50) NULL,
	[LOGINTIME] [datetime] NULL,
	[LOGOFFTIME] [datetime] NULL,
	[LOGLUPDATE] [int] NULL,
	[KICKOFF] [int] NULL,
	[PRODUCTMANAGER] [nvarchar](20) NULL,
	[EXTRATIME] [int] NULL,
	[ATTCAT] [nvarchar](50) NULL,
	[ATTLASTUPDATE] [datetime] NULL,
 CONSTRAINT [PK_EMPLOYEES] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[EMPNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Error_Log]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Error_Log](
	[ErrorId] [bigint] IDENTITY(1,1) NOT NULL,
	[Host] [nvarchar](50) NULL,
	[Type] [nvarchar](100) NULL,
	[Source] [nvarchar](60) NULL,
	[Message] [nvarchar](500) NULL,
	[Member_FK_Id] [bigint] NULL,
	[StatusCode] [int] NULL,
	[Time] [datetime] NULL,
	[Controller] [nvarchar](50) NULL,
	[Action] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MasterTable]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterTable](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[TypeId] [int] NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[ParentId] [bigint] NULL,
	[Show] [bit] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_MasterTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Member]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Member](
	[MemID] [bigint] IDENTITY(1,1) NOT NULL,
	[MemIdPreFix_DbUses] [nvarchar](50) NULL,
	[MemUserID] [nvarchar](50) NULL,
	[MemAutoGeneratedId] [bit] NOT NULL,
	[MemFirstName] [nvarchar](512) NULL,
	[MemLastName] [nvarchar](512) NULL,
	[MemNickName] [nvarchar](50) NULL,
	[MemFullName] [nvarchar](500) NULL,
	[MemEmailId] [nvarchar](500) NULL,
	[MemPassword] [nvarchar](1024) NULL,
	[MemPasswordSalt] [nvarchar](256) NULL,
	[MemMobileNo] [nvarchar](16) NULL,
	[MemPhoto] [image] NULL,
	[MemStatus_FK_Id] [bigint] NULL,
	[MemLastLoginOn] [datetime] NULL,
	[MemCreatedOn] [datetime] NULL,
	[MemCreatedBy_FK_Id] [bigint] NULL,
	[IsDeleted] [bit] NULL,
	[LoginType] [int] NULL,
	[UserId] [varchar](128) NULL,
	[MemberTypeId] [int] NULL,
	[EmpNo] [nvarchar](50) NULL,
	[CivilId] [int] NULL,
	[ExtNo] [nvarchar](50) NULL,
	[Department] [nvarchar](50) NULL,
	[Devision] [nvarchar](50) NULL,
	[Section] [nvarchar](50) NULL,
	[Title] [nvarchar](50) NULL,
	[SROOM] [int] NULL,
	[IsLogin] [bit] NULL,
	[Team] [bigint] NULL,
 CONSTRAINT [PK_Member] PRIMARY KEY CLUSTERED 
(
	[MemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[member_01042021]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[member_01042021](
	[MemID] [bigint] IDENTITY(1,1) NOT NULL,
	[MemIdPreFix_DbUses] [nvarchar](50) NULL,
	[MemUserID] [nvarchar](50) NULL,
	[MemAutoGeneratedId] [bit] NOT NULL,
	[MemFirstName] [nvarchar](512) NULL,
	[MemLastName] [nvarchar](512) NULL,
	[MemNickName] [nvarchar](50) NULL,
	[MemFullName] [nvarchar](500) NULL,
	[MemEmailId] [nvarchar](500) NULL,
	[MemPassword] [nvarchar](1024) NULL,
	[MemPasswordSalt] [nvarchar](256) NULL,
	[MemMobileNo] [nvarchar](16) NULL,
	[MemPhoto] [image] NULL,
	[MemStatus_FK_Id] [bigint] NULL,
	[MemLastLoginOn] [datetime] NULL,
	[MemCreatedOn] [datetime] NULL,
	[MemCreatedBy_FK_Id] [bigint] NULL,
	[IsDeleted] [bit] NULL,
	[LoginType] [int] NULL,
	[UserId] [varchar](128) NULL,
	[MemberTypeId] [int] NULL,
	[EmpNo] [nvarchar](50) NULL,
	[CivilId] [int] NULL,
	[ExtNo] [nvarchar](50) NULL,
	[Department] [nvarchar](50) NULL,
	[Devision] [nvarchar](50) NULL,
	[Section] [nvarchar](50) NULL,
	[Title] [nvarchar](50) NULL,
	[SROOM] [int] NULL,
	[IsLogin] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Member_04102021]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Member_04102021](
	[MemID] [bigint] IDENTITY(1,1) NOT NULL,
	[MemIdPreFix_DbUses] [nvarchar](50) NULL,
	[MemUserID] [nvarchar](50) NULL,
	[MemAutoGeneratedId] [bit] NOT NULL,
	[MemFirstName] [nvarchar](512) NULL,
	[MemLastName] [nvarchar](512) NULL,
	[MemNickName] [nvarchar](50) NULL,
	[MemFullName] [nvarchar](500) NULL,
	[MemEmailId] [nvarchar](500) NULL,
	[MemPassword] [nvarchar](1024) NULL,
	[MemPasswordSalt] [nvarchar](256) NULL,
	[MemMobileNo] [nvarchar](16) NULL,
	[MemPhoto] [image] NULL,
	[MemStatus_FK_Id] [bigint] NULL,
	[MemLastLoginOn] [datetime] NULL,
	[MemCreatedOn] [datetime] NULL,
	[MemCreatedBy_FK_Id] [bigint] NULL,
	[IsDeleted] [bit] NULL,
	[LoginType] [int] NULL,
	[UserId] [varchar](128) NULL,
	[MemberTypeId] [int] NULL,
	[EmpNo] [nvarchar](50) NULL,
	[CivilId] [int] NULL,
	[ExtNo] [nvarchar](50) NULL,
	[Department] [nvarchar](50) NULL,
	[Devision] [nvarchar](50) NULL,
	[Section] [nvarchar](50) NULL,
	[Title] [nvarchar](50) NULL,
	[SROOM] [int] NULL,
	[IsLogin] [bit] NULL,
	[Team] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Member_04102021_2]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Member_04102021_2](
	[MemID] [bigint] IDENTITY(1,1) NOT NULL,
	[MemIdPreFix_DbUses] [nvarchar](50) NULL,
	[MemUserID] [nvarchar](50) NULL,
	[MemAutoGeneratedId] [bit] NOT NULL,
	[MemFirstName] [nvarchar](512) NULL,
	[MemLastName] [nvarchar](512) NULL,
	[MemNickName] [nvarchar](50) NULL,
	[MemFullName] [nvarchar](500) NULL,
	[MemEmailId] [nvarchar](500) NULL,
	[MemPassword] [nvarchar](1024) NULL,
	[MemPasswordSalt] [nvarchar](256) NULL,
	[MemMobileNo] [nvarchar](16) NULL,
	[MemPhoto] [image] NULL,
	[MemStatus_FK_Id] [bigint] NULL,
	[MemLastLoginOn] [datetime] NULL,
	[MemCreatedOn] [datetime] NULL,
	[MemCreatedBy_FK_Id] [bigint] NULL,
	[IsDeleted] [bit] NULL,
	[LoginType] [int] NULL,
	[UserId] [varchar](128) NULL,
	[MemberTypeId] [int] NULL,
	[EmpNo] [nvarchar](50) NULL,
	[CivilId] [int] NULL,
	[ExtNo] [nvarchar](50) NULL,
	[Department] [nvarchar](50) NULL,
	[Devision] [nvarchar](50) NULL,
	[Section] [nvarchar](50) NULL,
	[Title] [nvarchar](50) NULL,
	[SROOM] [int] NULL,
	[IsLogin] [bit] NULL,
	[Team] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MemberType]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MemberType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberType] [nvarchar](256) NULL,
	[Status] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuMaster]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuMaster](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[NodeName] [nvarchar](256) NOT NULL,
	[NodeNameAR] [nvarchar](256) NULL,
	[NodeIcon] [nvarchar](max) NULL,
	[NodeLink] [nvarchar](max) NULL,
	[ParentId] [bigint] NULL,
	[IsActive] [bit] NULL,
	[SortOrder] [int] NULL,
 CONSTRAINT [PK_MenuMaster] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MIS_SMSMaster]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MIS_SMSMaster](
	[SMSMssterId] [int] IDENTITY(1,1) NOT NULL,
	[SMSText] [ntext] NULL,
	[ServiceId] [varchar](128) NULL,
	[A] [int] NULL,
	[D] [int] NULL,
	[C] [int] NULL,
	[Title] [varchar](128) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK__MIS_SMSM__CC1EE629283D9616] PRIMARY KEY CLUSTERED 
(
	[SMSMssterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MIS_SMSMasterHistory]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MIS_SMSMasterHistory](
	[SMSMssterHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[SMSText] [ntext] NULL,
	[SenderId] [varchar](128) NULL,
	[CustomerName] [nvarchar](256) NULL,
	[CMobile] [nvarchar](128) NULL,
	[DriverName] [nvarchar](256) NULL,
	[DMobile] [nvarchar](256) NULL,
	[CDATETIME] [datetime] NULL,
	[SendBy] [nvarchar](256) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK__MIS_SMSM__972A4AE77A526699] PRIMARY KEY CLUSTERED 
(
	[SMSMssterHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MST_Company]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MST_Company](
	[CompanyId] [int] IDENTITY(1,1) NOT NULL,
	[Comp_Code] [int] NULL,
	[Desc_Eng] [nvarchar](256) NULL,
	[Desc_Arb] [nvarchar](256) NULL,
	[Status] [char](1) NULL,
	[cDateTime] [datetime] NULL,
 CONSTRAINT [PK_MST_Company] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MST_Department]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MST_Department](
	[DepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[Dept_Code] [int] NULL,
	[Desc_Eng] [nvarchar](256) NULL,
	[Desc_Arb] [nvarchar](256) NULL,
	[Status] [char](1) NULL,
	[cDateTime] [datetime] NULL,
	[Comp_Code] [int] NULL,
 CONSTRAINT [PK_MST_Department] PRIMARY KEY CLUSTERED 
(
	[DepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MST_Division]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MST_Division](
	[DivisionId] [int] IDENTITY(1,1) NOT NULL,
	[Div_Code] [int] NULL,
	[Desc_Eng] [nvarchar](256) NULL,
	[Desc_Arb] [nvarchar](256) NULL,
	[Status] [char](1) NULL,
	[cDateTime] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MST_Language]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MST_Language](
	[LanguageId] [int] IDENTITY(1,1) NOT NULL,
	[Desc_Eng] [nvarchar](256) NULL,
	[Desc_Arb] [nvarchar](256) NULL,
	[Status] [char](1) NULL,
	[cDateTime] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MST_Section]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MST_Section](
	[SectionId] [int] IDENTITY(1,1) NOT NULL,
	[Desc_Eng] [nvarchar](256) NULL,
	[Desc_Arb] [nvarchar](256) NULL,
	[Status] [char](1) NULL,
	[cDateTime] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MST_Title]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MST_Title](
	[TitleId] [int] IDENTITY(1,1) NOT NULL,
	[Desc_Eng] [nvarchar](256) NULL,
	[Desc_Arb] [nvarchar](256) NULL,
	[Status] [char](1) NULL,
	[cDateTime] [datetime] NULL,
 CONSTRAINT [PK_MST_Title] PRIMARY KEY CLUSTERED 
(
	[TitleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MT_ProjectCategory]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MT_ProjectCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MT_ProjectStatus]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MT_ProjectStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewCallData$]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewCallData$](
	[CallId] [float] NULL,
	[CallDate] [datetime] NULL,
	[CallBy] [nvarchar](255) NULL,
	[CallerId] [float] NULL,
	[CallerNo] [float] NULL,
	[CallerName] [nvarchar](255) NULL,
	[CallGroup] [nvarchar](255) NULL,
	[CAllCategory] [nvarchar](255) NULL,
	[CAllTemplate] [nvarchar](255) NULL,
	[CallAssignedTo] [nvarchar](255) NULL,
	[CallDesc] [nvarchar](255) NULL,
	[CallPriority] [nvarchar](255) NULL,
	[CallStatus] [nvarchar](255) NULL,
	[CAllClosedBy] [nvarchar](255) NULL,
	[ClosedDate] [datetime] NULL,
	[IsSrno] [nvarchar](255) NULL,
	[Seen] [float] NULL,
	[SeenDate] [nvarchar](255) NULL,
	[F19] [nvarchar](255) NULL,
	[F20] [nvarchar](255) NULL,
	[F21] [nvarchar](255) NULL,
	[F22] [nvarchar](255) NULL,
	[CallById] [int] NULL,
	[CallAssignToId] [int] NULL,
	[TemplateId] [int] NULL,
	[CAllClosedById] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OUTGOING_SMS]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OUTGOING_SMS](
	[SMS_SERIAL] [bigint] IDENTITY(1,1) NOT NULL,
	[SMS_SENDER_ID] [int] NULL,
	[SMS_MOBILE] [bigint] NULL,
	[SMS_TEXT] [nvarchar](1071) NULL,
	[SMS_IS_SENT] [bit] NULL,
	[SMS_TRAILS_COUNT] [tinyint] NULL,
	[SMS_INSERTED_AT] [datetime] NULL,
	[SMS_SENT_AT] [datetime] NULL,
	[SMS_MSG_ID] [nvarchar](65) NULL,
	[SMS_COST] [decimal](30, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PARAMETERS]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PARAMETERS](
	[CATEG] [nvarchar](30) NULL,
	[DESCNEW] [nvarchar](30) NULL,
	[POINTS] [float] NULL,
	[CATEG2] [nvarchar](20) NULL,
	[CATEG3] [nvarchar](20) NULL,
	[CATEG4] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ParameterSetup]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ParameterSetup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TablesName_FK_Id] [int] NULL,
	[FieldName] [nvarchar](128) NULL,
	[FieldDataType] [int] NULL,
	[FieldLabel] [nvarchar](1024) NULL,
	[IsForeignKey] [bit] NULL,
	[ForeignKeyTable_FK_Id] [int] NULL,
	[Cascading] [nvarchar](128) NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_ParameterSetup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ParametersList]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ParametersList](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[TablesName_FK_Id] [int] NULL,
	[Show] [bit] NULL,
	[SortOrder] [int] NULL,
	[ValueField1] [nvarchar](max) NULL,
	[ValueField2] [nvarchar](max) NULL,
	[ValueField3] [nvarchar](max) NULL,
	[ValueField4] [nvarchar](max) NULL,
	[ValueField5] [nvarchar](max) NULL,
	[ValueField6] [nvarchar](max) NULL,
	[ValueField7] [nvarchar](max) NULL,
	[ValueField8] [nvarchar](max) NULL,
	[ValueField9] [nvarchar](max) NULL,
	[ValueField10] [nvarchar](max) NULL,
	[ValueField11] [nvarchar](max) NULL,
	[ValueField12] [nvarchar](max) NULL,
	[ValueField13] [nvarchar](max) NULL,
	[ValueField14] [nvarchar](max) NULL,
	[ValueField15] [nvarchar](max) NULL,
	[ValueField16] [nvarchar](max) NULL,
	[ValueField17] [nvarchar](max) NULL,
	[ValueField18] [nvarchar](max) NULL,
	[ValueField19] [nvarchar](max) NULL,
	[ValueField20] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
 CONSTRAINT [PK_ParametersList] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PeoplePrivileges]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeoplePrivileges](
	[People_PrivilegeId] [bigint] IDENTITY(1,1) NOT NULL,
	[Page_FK_Id] [bigint] NULL,
	[Privilege_FK_Id] [int] NULL,
	[People_FK_Id] [bigint] NULL,
	[IsTrue] [bit] NULL,
	[IsGranted] [bit] NULL,
	[IsDeny] [bit] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_People_Privileges] PRIMARY KEY CLUSTERED 
(
	[People_PrivilegeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PeoplePrivileges3009201]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeoplePrivileges3009201](
	[People_PrivilegeId] [bigint] IDENTITY(1,1) NOT NULL,
	[Page_FK_Id] [bigint] NULL,
	[Privilege_FK_Id] [int] NULL,
	[People_FK_Id] [bigint] NULL,
	[IsTrue] [bit] NULL,
	[IsGranted] [bit] NULL,
	[IsDeny] [bit] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PeopleRoles]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeopleRoles](
	[People_RolesId] [bigint] IDENTITY(1,1) NOT NULL,
	[People_FK_Id] [bigint] NULL,
	[Role_FK_Id] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_People_Roles] PRIMARY KEY CLUSTERED 
(
	[People_RolesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMS_MASTER_TABLE]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMS_MASTER_TABLE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NAME] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMSEmailHistory]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMSEmailHistory](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[E_From] [nvarchar](200) NULL,
	[E_To] [nvarchar](500) NULL,
	[E_Cc] [nvarchar](500) NULL,
	[E_Subject] [nvarchar](500) NULL,
	[E_Message] [nvarchar](500) NULL,
	[E_Status] [nvarchar](20) NULL,
	[E_Date] [datetime] NULL,
	[Note] [nvarchar](200) NULL,
	[S_Type] [nvarchar](20) NULL,
	[Item_Id] [bigint] NULL,
	[Task_Id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PrivilegeActions]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrivilegeActions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Privilege] [nvarchar](128) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_PrivilegeActions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PrivilegeActions_30032021]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrivilegeActions_30032021](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Privilege] [nvarchar](128) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PrivilegeActions_30092021]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrivilegeActions_30092021](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Privilege] [nvarchar](128) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](256) NULL,
	[IsActive] [bit] NULL,
	[SortOrder] [int] NULL,
	[IsEditable] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RolesPrivileges]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolesPrivileges](
	[RolePrivilegesId] [int] IDENTITY(1,1) NOT NULL,
	[Role_FK_Id] [int] NULL,
	[PageId] [int] NULL,
	[Privilege_FK_Id] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDate] [datetime] NULL,
	[IsTrue] [bit] NULL,
 CONSTRAINT [PK_Roles_Privileges] PRIMARY KEY CLUSTERED 
(
	[RolePrivilegesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RolesPrivileges30092021]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolesPrivileges30092021](
	[RolePrivilegesId] [int] IDENTITY(1,1) NOT NULL,
	[Role_FK_Id] [int] NULL,
	[PageId] [int] NULL,
	[Privilege_FK_Id] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDate] [datetime] NULL,
	[IsTrue] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sheet1$]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sheet1$](
	[ActId] [float] NULL,
	[CallId] [float] NULL,
	[ActBY] [nvarchar](255) NULL,
	[ActDate] [datetime] NULL,
	[ActNo] [nvarchar](255) NULL,
	[ActDesc] [nvarchar](255) NULL,
	[ActStatus] [nvarchar](255) NULL,
	[ActById] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sheet2$]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sheet2$](
	[ActId] [float] NULL,
	[CallId] [float] NULL,
	[ActBY] [nvarchar](255) NULL,
	[ActDate] [datetime] NULL,
	[ActNo] [float] NULL,
	[ActDesc] [nvarchar](255) NULL,
	[ActStatus] [nvarchar](255) NULL,
	[ActById] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SROOM]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SROOM](
	[SROOM] [int] IDENTITY(1,1) NOT NULL,
	[sROOMDESC] [nvarchar](1200) NULL,
	[SROOMA] [nvarchar](512) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_SROOM] PRIMARY KEY CLUSTERED 
(
	[SROOM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SROOM_14042021]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SROOM_14042021](
	[SROOM] [int] IDENTITY(1,1) NOT NULL,
	[sROOMDESC] [nvarchar](1200) NULL,
	[SROOMA] [nvarchar](512) NULL,
	[Status] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TablesName]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TablesName](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [nvarchar](512) NULL,
	[IsEditable] [bit] NULL,
	[ParentID] [int] NULL,
	[HierarchyLevel] [int] NULL,
 CONSTRAINT [PK_TablesName] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblActionTemplate]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblActionTemplate](
	[ActionTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[ActionTemplate] [nvarchar](1028) NULL,
	[ActionType] [varchar](128) NULL,
	[Status] [int] NULL,
	[cDateTime] [datetime] NULL,
 CONSTRAINT [PK__tblActio__75C9BB0F56ABF883] PRIMARY KEY CLUSTERED 
(
	[ActionTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAssetAction]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAssetAction](
	[AssetActionId] [int] IDENTITY(1,1) NOT NULL,
	[AssetStockId] [int] NULL,
	[ActBy] [int] NULL,
	[ActDate] [datetime] NULL,
	[ActDescriptionUser] [nvarchar](512) NULL,
	[ActDescriptionSystem] [nvarchar](512) NULL,
	[ActStatus] [nvarchar](128) NULL,
	[Status] [int] NULL,
	[cDateTime] [datetime] NULL,
 CONSTRAINT [PK__tblAsset__CF7ED0229D4D38C9] PRIMARY KEY CLUSTERED 
(
	[AssetActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAssetBrand]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAssetBrand](
	[AssetBrandId] [int] IDENTITY(1,1) NOT NULL,
	[AssetTypeId] [int] NULL,
	[AssetCategoryId] [int] NULL,
	[AssetBrand] [nvarchar](256) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK__tblAsset__5DE460AEFB306453] PRIMARY KEY CLUSTERED 
(
	[AssetBrandId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAssetCategory]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAssetCategory](
	[AssetCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[AssetTypeId] [int] NULL,
	[AssetCategory] [nvarchar](256) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK__tblAsset__C381F47DAA174608] PRIMARY KEY CLUSTERED 
(
	[AssetCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAssetReqFor]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAssetReqFor](
	[AssetReqForId] [int] IDENTITY(1,1) NOT NULL,
	[AssetReqFor] [nvarchar](512) NULL,
	[cDateTime] [datetime] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK__tblAsset__3F9623E7B6D6D4E1] PRIMARY KEY CLUSTERED 
(
	[AssetReqForId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAssetStock]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAssetStock](
	[AssetStockId] [int] IDENTITY(1,1) NOT NULL,
	[Comp_Code] [int] NULL,
	[DepartmentId] [int] NULL,
	[AssetTypeId] [int] NULL,
	[AssetCategoryId] [int] NULL,
	[AssetBrandId] [int] NULL,
	[AssetDescription] [nvarchar](512) NULL,
	[AssetSerialNo] [nvarchar](128) NULL,
	[AssetBarcode] [nvarchar](128) NULL,
	[AssetStatus] [varchar](128) NULL,
	[AssigendTo] [bigint] NULL,
	[Assigned_Date] [datetime] NULL,
	[AssigendBy] [bigint] NULL,
	[Assigned_Condition] [nvarchar](256) NULL,
	[Current_Location] [nvarchar](256) NULL,
	[Status] [int] NULL,
	[cDateTime] [datetime] NULL,
 CONSTRAINT [PK__tblAsset__1C7CF8635215BFFE] PRIMARY KEY CLUSTERED 
(
	[AssetStockId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAssetStockDetail]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAssetStockDetail](
	[AssetStockDetailId] [int] IDENTITY(1,1) NOT NULL,
	[AssetStockId] [int] NULL,
	[AssetValue] [decimal](30, 3) NULL,
	[RequestNo] [varchar](128) NULL,
	[Po_No] [varchar](128) NULL,
	[InvoiceNo] [varchar](128) NULL,
	[ReceivingDate] [datetime] NULL,
	[ReceivedBy] [int] NULL,
	[Asset_warrenty_Year] [varchar](128) NULL,
	[Asset_Warrenty_ExpDate] [datetime] NULL,
	[Asset_Depreation_Percentage] [int] NULL,
	[Asset_Depreation_Date] [datetime] NULL,
	[Asset_Depreation_value] [decimal](30, 3) NULL,
	[RetiredBy] [int] NULL,
	[Retireddate] [datetime] NULL,
	[SoldBy] [int] NULL,
	[SoldDate] [datetime] NULL,
	[SoldPrice] [decimal](30, 3) NULL,
	[Status] [int] NULL,
	[cDateTime] [datetime] NULL,
	[ReturnBy] [int] NULL,
	[ReturnDate] [datetime] NULL,
	[ReturnCondition] [nvarchar](256) NULL,
	[MaintenceBy] [int] NULL,
	[MantainStartDate] [datetime] NULL,
	[MaintainDescription] [nvarchar](256) NULL,
	[ScrapBy] [int] NULL,
	[ScrapDate] [datetime] NULL,
 CONSTRAINT [PK__tblAsset__F4EC2205DF7B3361] PRIMARY KEY CLUSTERED 
(
	[AssetStockDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAssetType]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAssetType](
	[AssetTypeId] [int] IDENTITY(1,1) NOT NULL,
	[AssetType] [nvarchar](512) NULL,
	[cDateTime] [datetime] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK__tblAsset__FD33C2C28106E51E] PRIMARY KEY CLUSTERED 
(
	[AssetTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCall]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCall](
	[CallId] [bigint] IDENTITY(1,1) NOT NULL,
	[CallerId] [bigint] NULL,
	[CallGroupId] [int] NULL,
	[CallCategoryId] [int] NULL,
	[CallTemplateId] [int] NULL,
	[CallDescription] [nvarchar](512) NULL,
	[CallDate] [datetime] NULL,
	[CallPriorityId] [int] NULL,
	[CallAssignedTo] [bigint] NULL,
	[CallCloseBy] [bigint] NULL,
	[ClosedDate] [datetime] NULL,
	[ISSeen] [int] NULL,
	[SeenDate] [datetime] NULL,
	[CallStatus] [varchar](128) NULL,
	[Status] [int] NULL,
	[cDateTime] [datetime] NULL,
	[CallBy] [bigint] NULL,
	[CallDesc2] [nvarchar](512) NULL,
	[IsCancelCall] [int] NULL,
	[CallIdOld] [int] NULL,
	[CreatedBy] [bigint] NULL,
 CONSTRAINT [PK__tblCall__5180CFAA11263395] PRIMARY KEY CLUSTERED 
(
	[CallId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCall_14022015]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCall_14022015](
	[CallId] [bigint] IDENTITY(1,1) NOT NULL,
	[CallerId] [bigint] NULL,
	[CallGroupId] [int] NULL,
	[CallCategoryId] [int] NULL,
	[CallTemplateId] [int] NULL,
	[CallDescription] [nvarchar](512) NULL,
	[CallDate] [datetime] NULL,
	[CallPriorityId] [int] NULL,
	[CallAssignedTo] [bigint] NULL,
	[CallCloseBy] [bigint] NULL,
	[ClosedDate] [datetime] NULL,
	[ISSeen] [int] NULL,
	[SeenDate] [datetime] NULL,
	[CallStatus] [varchar](128) NULL,
	[Status] [int] NULL,
	[cDateTime] [datetime] NULL,
	[CallBy] [bigint] NULL,
	[CallDesc2] [nvarchar](512) NULL,
	[IsCancelCall] [int] NULL,
	[CallIdOld] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCall_Temp]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCall_Temp](
	[CallId_Temp] [bigint] IDENTITY(1,1) NOT NULL,
	[CallId] [bigint] NULL,
	[CallerId] [bigint] NULL,
	[CallGroupId] [int] NULL,
	[CallCategoryId] [int] NULL,
	[CallTemplateId] [int] NULL,
	[CallDescription] [nvarchar](512) NULL,
	[CallDate] [datetime] NULL,
	[CallPriorityId] [int] NULL,
	[CallAssignedTo] [bigint] NULL,
	[CallCloseBy] [bigint] NULL,
	[ClosedDate] [datetime] NULL,
	[ISSeen] [int] NULL,
	[SeenDate] [datetime] NULL,
	[CallStatus] [varchar](128) NULL,
	[Status] [int] NULL,
	[cDateTime] [datetime] NULL,
	[CallBy] [bigint] NULL,
	[CallDesc2] [nvarchar](512) NULL,
	[IsCancelCall] [int] NULL,
	[CallIdOld] [int] NULL,
	[CreatedBy] [bigint] NULL,
 CONSTRAINT [PK__tblCall___D536AE692A3B43B4] PRIMARY KEY CLUSTERED 
(
	[CallId_Temp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCallAction]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCallAction](
	[CallActionId] [bigint] IDENTITY(1,1) NOT NULL,
	[CallId] [bigint] NULL,
	[ActBy] [int] NULL,
	[ActDate] [datetime] NULL,
	[ActNO] [int] NULL,
	[ActDescription] [nvarchar](512) NULL,
	[ActStatus] [varchar](128) NULL,
	[Status] [int] NULL,
	[cDateTime] [datetime] NULL,
	[IsSeen] [int] NULL,
	[SeenBy] [int] NULL,
	[SeenDate] [datetime] NULL,
	[IsSeenE] [int] NULL,
	[SeenByE] [int] NULL,
	[SeenDateE] [datetime] NULL,
	[ISSMS] [int] NULL,
	[IsMail] [int] NULL,
 CONSTRAINT [PK__tblCallA__124ED4E6FB3D66BA] PRIMARY KEY CLUSTERED 
(
	[CallActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCallCategory]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCallCategory](
	[CallCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CallGroupId] [int] NULL,
	[CallCategory] [nvarchar](255) NULL,
	[Status] [int] NULL,
	[CDATETime] [datetime] NULL,
 CONSTRAINT [PK__tblCallC__883E85DFD89A5752] PRIMARY KEY CLUSTERED 
(
	[CallCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCallGroup]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCallGroup](
	[CallGroupId] [int] IDENTITY(1,1) NOT NULL,
	[CallGroup] [nvarchar](255) NULL,
	[Status] [int] NULL,
	[CDATETime] [datetime] NULL,
	[GroupHeadId] [int] NULL,
 CONSTRAINT [PK__tblCallG__D1081D424A8B1D0E] PRIMARY KEY CLUSTERED 
(
	[CallGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCallPriority]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCallPriority](
	[CallPriorityId] [int] IDENTITY(1,1) NOT NULL,
	[CallPriority] [nvarchar](256) NULL,
	[Status] [int] NULL,
	[CDateTime] [datetime] NULL,
 CONSTRAINT [PK__tblCallP__772769075DFF943E] PRIMARY KEY CLUSTERED 
(
	[CallPriorityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCallTemplate]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCallTemplate](
	[CallTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[CallGroupId] [int] NULL,
	[CallCategoryId] [int] NULL,
	[CallTemplate] [nvarchar](255) NULL,
	[Status] [int] NULL,
	[CDATETime] [datetime] NULL,
 CONSTRAINT [PK__tblCallT__C69CF0217AC2AB41] PRIMARY KEY CLUSTERED 
(
	[CallTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCallUploadItems]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCallUploadItems](
	[CallUploadItemId] [int] IDENTITY(1,1) NOT NULL,
	[CallId] [bigint] NULL,
	[Description] [nvarchar](256) NULL,
	[FileName] [varchar](256) NULL,
	[FileUrl] [nvarchar](256) NULL,
	[UploadType] [int] NULL,
	[Status] [int] NULL,
	[cDateTime] [datetime] NULL,
 CONSTRAINT [PK__tblCallU__32D3B37BFB6703AB] PRIMARY KEY CLUSTERED 
(
	[CallUploadItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblEmail]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEmail](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[MailId] [nvarchar](200) NULL,
	[Category] [nvarchar](50) NULL,
	[Type] [nvarchar](20) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblItemRequest]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblItemRequest](
	[ItemRequestId] [int] IDENTITY(1,1) NOT NULL,
	[AssetTypeId] [int] NULL,
	[RequestBy] [bigint] NULL,
	[AssetReqForId] [int] NULL,
	[AssetDescription] [nvarchar](512) NULL,
	[ReasonDescription] [nvarchar](512) NULL,
	[RequestDate] [datetime] NULL,
	[RequestTo] [bigint] NULL,
	[Qty] [int] NULL,
	[ApproveByOwnDept] [bigint] NULL,
	[ApproveByItDept] [bigint] NULL,
	[IsDirectApprove] [int] NULL,
	[Status] [int] NULL,
	[ReasonCategoryId] [int] NULL,
	[ReqStatus] [nvarchar](128) NULL,
	[CloseBy] [bigint] NULL,
 CONSTRAINT [PK__tblItemR__0300A13D97D3AA60] PRIMARY KEY CLUSTERED 
(
	[ItemRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblItemRequestAction]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblItemRequestAction](
	[ItemRequestActionId] [int] IDENTITY(1,1) NOT NULL,
	[ItemRequestId] [int] NULL,
	[RequestAction] [nvarchar](512) NULL,
	[ActBy] [bigint] NULL,
	[ActStatus] [varchar](128) NULL,
	[ActDate] [datetime] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK__tblItemR__D1B4BBF79A716C7C] PRIMARY KEY CLUSTERED 
(
	[ItemRequestActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblNotification]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblNotification](
	[NotificationId] [bigint] IDENTITY(1,1) NOT NULL,
	[NotificationFrom] [nvarchar](256) NULL,
	[NotificationTo] [nvarchar](256) NULL,
	[ApplicationName] [nvarchar](256) NULL,
	[Description] [nvarchar](512) NULL,
	[Status] [int] NULL,
	[cDateTime] [datetime] NULL,
	[NotificationFromId] [int] NULL,
	[NotificationToId] [int] NULL,
	[CallId] [bigint] NULL,
 CONSTRAINT [PK__tblNotif__20CF2E12C37E977B] PRIMARY KEY CLUSTERED 
(
	[NotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblNotification_Temp]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblNotification_Temp](
	[NotificationId] [bigint] IDENTITY(1,1) NOT NULL,
	[NotificationFrom] [nvarchar](256) NULL,
	[NotificationTo] [nvarchar](256) NULL,
	[ApplicationName] [nvarchar](256) NULL,
	[Description] [nvarchar](512) NULL,
	[Status] [int] NULL,
	[cDateTime] [datetime] NULL,
	[NotificationFromId] [int] NULL,
	[NotificationToId] [int] NULL,
	[CallId] [bigint] NULL,
 CONSTRAINT [PK__tblNotif__20CF2E1217B22AA5] PRIMARY KEY CLUSTERED 
(
	[NotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPageMaster]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPageMaster](
	[PageId] [int] IDENTITY(1,1) NOT NULL,
	[PageName] [nvarchar](256) NULL,
	[PageUrl] [nvarchar](256) NULL,
	[OrderBY] [int] NULL,
	[ParentId] [int] NULL,
	[Status] [int] NULL,
	[cDateTime] [datetime] NULL,
	[ProjectId] [int] NULL,
 CONSTRAINT [PK__tblPageM__C565B104490F1F46] PRIMARY KEY CLUSTERED 
(
	[PageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProject]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProject](
	[Pm_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Comp_Code] [int] NULL,
	[CompanyName] [int] NULL,
	[Dept_Code] [int] NULL,
	[Div_Code] [int] NULL,
	[OwnerName] [bigint] NULL,
	[Category] [nvarchar](255) NULL,
	[ProjectName] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[PromiseDate] [datetime] NULL,
	[FinishDate] [datetime] NULL,
	[Percentage] [float] NULL,
	[HandeledByTeam] [bigint] NULL,
	[DevelopedBy] [bigint] NULL,
	[CreateOn] [datetime] NULL,
	[Project_Description] [nvarchar](max) NULL,
	[CreatedBy] [bigint] NULL,
	[FollowUpBy] [bigint] NULL,
	[CallId] [bigint] NULL,
	[MailCC] [nvarchar](512) NULL,
	[BenefitForCompany] [nvarchar](1012) NULL,
	[RequestedBy] [uniqueidentifier] NULL,
	[AssignedTo] [uniqueidentifier] NULL,
	[FollowUp] [uniqueidentifier] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_tblProject] PRIMARY KEY CLUSTERED 
(
	[Pm_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProject_ALI_05102021]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProject_ALI_05102021](
	[Pm_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Comp_Code] [int] NULL,
	[CompanyName] [int] NULL,
	[Dept_Code] [int] NULL,
	[Div_Code] [int] NULL,
	[OwnerName] [bigint] NULL,
	[Category] [nvarchar](255) NULL,
	[ProjectName] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[PromiseDate] [datetime] NULL,
	[FinishDate] [datetime] NULL,
	[Percentage] [float] NULL,
	[Status] [nvarchar](255) NULL,
	[HandeledByTeam] [bigint] NULL,
	[DevelopedBy] [bigint] NULL,
	[CreateOn] [datetime] NULL,
	[Project_Description] [nvarchar](max) NULL,
	[CreatedBy] [bigint] NULL,
	[FollowUpBy] [bigint] NULL,
	[CallId] [bigint] NULL,
	[MailCC] [nvarchar](512) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProject13102021]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProject13102021](
	[Pm_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Comp_Code] [int] NULL,
	[CompanyName] [int] NULL,
	[Dept_Code] [int] NULL,
	[Div_Code] [int] NULL,
	[OwnerName] [bigint] NULL,
	[Category] [nvarchar](255) NULL,
	[ProjectName] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[PromiseDate] [datetime] NULL,
	[FinishDate] [datetime] NULL,
	[Percentage] [float] NULL,
	[Status] [nvarchar](255) NULL,
	[HandeledByTeam] [bigint] NULL,
	[DevelopedBy] [bigint] NULL,
	[CreateOn] [datetime] NULL,
	[Project_Description] [nvarchar](max) NULL,
	[CreatedBy] [bigint] NULL,
	[FollowUpBy] [bigint] NULL,
	[CallId] [bigint] NULL,
	[MailCC] [nvarchar](512) NULL,
	[BenefitForCompany] [nvarchar](1012) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProject30092021]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProject30092021](
	[Pm_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Comp_Code] [int] NULL,
	[CompanyName] [int] NULL,
	[Dept_Code] [int] NULL,
	[Div_Code] [int] NULL,
	[OwnerName] [bigint] NULL,
	[Category] [nvarchar](255) NULL,
	[ProjectName] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[PromiseDate] [datetime] NULL,
	[FinishDate] [datetime] NULL,
	[Percentage] [float] NULL,
	[Status] [nvarchar](255) NULL,
	[HandeledByTeam] [bigint] NULL,
	[DevelopedBy] [bigint] NULL,
	[CreateOn] [datetime] NULL,
	[Project_Description] [nvarchar](max) NULL,
	[CreatedBy] [bigint] NULL,
	[FollowUpBy] [bigint] NULL,
	[CallId] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProjectDetail]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjectDetail](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Project_FK_Id] [bigint] NULL,
	[Comment] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[cDatetime] [datetime] NULL,
	[ActionBy] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Status] [nvarchar](128) NULL,
	[AssignTo] [int] NULL,
	[CallGroup] [int] NULL,
	[CallId] [int] NULL,
	[ReOpen] [int] NULL,
	[ReopenBy] [bigint] NULL,
	[File] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
 CONSTRAINT [PK_tblProjectDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProjectDetail_ALI_05102021]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjectDetail_ALI_05102021](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Project_FK_Id] [bigint] NULL,
	[Comment] [nvarchar](max) NULL,
	[cDatetime] [datetime] NULL,
	[ActionBy] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Status] [nvarchar](128) NULL,
	[AssignTo] [int] NULL,
	[CallGroup] [int] NULL,
	[CallId] [int] NULL,
	[ReOpen] [int] NULL,
	[ReopenBy] [bigint] NULL,
	[File] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProjectDetail13102021]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjectDetail13102021](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Project_FK_Id] [bigint] NULL,
	[Comment] [nvarchar](max) NULL,
	[cDatetime] [datetime] NULL,
	[ActionBy] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Status] [nvarchar](128) NULL,
	[AssignTo] [int] NULL,
	[CallGroup] [int] NULL,
	[CallId] [int] NULL,
	[ReOpen] [int] NULL,
	[ReopenBy] [bigint] NULL,
	[File] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProjectDetail30092021]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjectDetail30092021](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Project_FK_Id] [bigint] NULL,
	[Comment] [nvarchar](max) NULL,
	[cDatetime] [datetime] NULL,
	[ActionBy] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Status] [nvarchar](128) NULL,
	[AssignTo] [int] NULL,
	[CallGroup] [int] NULL,
	[CallId] [int] NULL,
	[ReOpen] [int] NULL,
	[ReopenBy] [bigint] NULL,
	[File] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProjectDetailHistory]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjectDetailHistory](
	[H_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Id] [bigint] NOT NULL,
	[Project_FK_Id] [bigint] NULL,
	[Comment] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[cDatetime] [datetime] NULL,
	[ActionBy] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Status] [nvarchar](128) NULL,
	[AssignTo] [int] NULL,
	[CallGroup] [int] NULL,
	[CallId] [int] NULL,
	[ReOpen] [int] NULL,
	[ReopenBy] [bigint] NULL,
	[File] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[ActionType] [nvarchar](50) NULL,
	[ActionDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[H_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProjectHistory]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjectHistory](
	[H_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Pm_Id] [bigint] NOT NULL,
	[Comp_Code] [int] NULL,
	[CompanyName] [int] NULL,
	[Dept_Code] [int] NULL,
	[Div_Code] [int] NULL,
	[OwnerName] [bigint] NULL,
	[Category] [nvarchar](255) NULL,
	[ProjectName] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[PromiseDate] [datetime] NULL,
	[FinishDate] [datetime] NULL,
	[Percentage] [float] NULL,
	[Status] [nvarchar](255) NULL,
	[HandeledByTeam] [bigint] NULL,
	[DevelopedBy] [bigint] NULL,
	[CreateOn] [datetime] NULL,
	[Project_Description] [nvarchar](max) NULL,
	[CreatedBy] [bigint] NULL,
	[FollowUpBy] [bigint] NULL,
	[CallId] [bigint] NULL,
	[MailCC] [nvarchar](512) NULL,
	[BenefitForCompany] [nvarchar](1012) NULL,
	[ActionType] [nvarchar](50) NULL,
	[ActionDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[H_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblReasonCategory]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReasonCategory](
	[ReasonCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[ReasonCategory] [nvarchar](512) NULL,
	[cDateTime] [datetime] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK__tblReaso__52D77675D20F2B01] PRIMARY KEY CLUSTERED 
(
	[ReasonCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblRoleprivileges]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRoleprivileges](
	[RoleprivilegesId] [int] IDENTITY(1,1) NOT NULL,
	[PageId] [int] NULL,
	[TitleId] [int] NULL,
	[Addprivilege] [int] NULL,
	[Editprivilege] [int] NULL,
	[Deleteprivilege] [int] NULL,
	[Viewprivilege] [int] NULL,
	[Printprivilege] [int] NULL,
	[Totalprivilege] [int] NULL,
	[Field1privilege] [int] NULL,
	[Field2privilege] [int] NULL,
	[ParentId] [int] NULL,
	[Status] [int] NULL,
	[CDateTime] [datetime] NULL,
 CONSTRAINT [PK__tblRolep__C4B6C380955BDF39] PRIMARY KEY CLUSTERED 
(
	[RoleprivilegesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTemp]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTemp](
	[UserLoginId] [bigint] NULL,
	[UserName] [nvarchar](256) NULL,
	[Mobile] [nvarchar](256) NULL,
	[Email] [nvarchar](256) NULL,
	[EmpNo] [nvarchar](256) NULL,
	[Company] [int] NULL,
	[Department] [int] NULL,
	[Division] [int] NULL,
	[Section] [int] NULL,
	[Title] [int] NULL,
	[Reportingto] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTempCategory]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTempCategory](
	[TempCategoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[TempCategory] [nvarchar](256) NULL,
	[Status] [bit] NULL,
	[cDateTime] [datetime] NULL,
 CONSTRAINT [PK_tblTempCategory] PRIMARY KEY CLUSTERED 
(
	[TempCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTemplate]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTemplate](
	[TemplateId] [bigint] IDENTITY(1,1) NOT NULL,
	[TempCategory_Fk_Id] [bigint] NULL,
	[Template] [nvarchar](max) NULL,
	[Status] [bit] NULL,
	[cDateTime] [datetime] NULL,
 CONSTRAINT [PK_tblTemplate] PRIMARY KEY CLUSTERED 
(
	[TemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUserDetail]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserDetail](
	[UserDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserLoginId] [bigint] NULL,
	[EMPNo] [bigint] NULL,
	[LanguageId] [int] NULL,
	[BirthDate] [datetime] NULL,
	[CompanyId] [int] NULL,
	[DepartmentId] [int] NULL,
	[DivisionId] [int] NULL,
	[SectionId] [int] NULL,
	[TitleId] [int] NULL,
	[Home] [varchar](128) NULL,
	[Direct] [varchar](128) NULL,
	[Fax] [varchar](128) NULL,
	[Ext] [varchar](128) NULL,
	[ReportingTo] [nvarchar](256) NULL,
	[EmpStatus] [varchar](128) NULL,
	[Status] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[Address] [nvarchar](max) NULL,
 CONSTRAINT [PK__tblUserD__564F56B2842A1238] PRIMARY KEY CLUSTERED 
(
	[UserDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUserFeedBack]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserFeedBack](
	[UserFeedBackId] [int] IDENTITY(1,1) NOT NULL,
	[CallId] [bigint] NULL,
	[FeedBackBy] [int] NULL,
	[FeedBack] [nvarchar](512) NULL,
	[Rating] [int] NULL,
	[Status] [int] NULL,
	[cDateTime] [datetime] NULL,
	[RatingStatus] [nvarchar](256) NULL,
 CONSTRAINT [PK__tblUserF__F4390F390C0AE511] PRIMARY KEY CLUSTERED 
(
	[UserFeedBackId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUserLogin]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserLogin](
	[UserLoginId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](256) NULL,
	[Password] [nvarchar](256) NULL,
	[Name] [nvarchar](256) NULL,
	[Mobile] [varchar](128) NULL,
	[Email] [varchar](128) NULL,
	[Status] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[LoginType] [int] NULL,
	[IsUserLoggedIn] [int] NULL,
	[UserId] [varchar](128) NULL,
	[Picture] [nvarchar](512) NULL,
	[UserTypeId] [int] NULL,
	[ISSMS] [int] NULL,
	[IsMail] [int] NULL,
	[TempPassword] [varchar](20) NULL,
	[Team] [bigint] NULL,
	[RequestedBy] [int] NULL,
	[FollowUpBy] [int] NULL,
 CONSTRAINT [PK__tblUserL__107D568C20A2C871] PRIMARY KEY CLUSTERED 
(
	[UserLoginId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUserprivileges]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserprivileges](
	[UserprivilegesId] [int] IDENTITY(1,1) NOT NULL,
	[PageId] [int] NULL,
	[UserLoginId] [bigint] NULL,
	[Addprivilege] [int] NULL,
	[Editprivilege] [int] NULL,
	[Deleteprivilege] [int] NULL,
	[Viewprivilege] [int] NULL,
	[Printprivilege] [int] NULL,
	[Totalprivilege] [int] NULL,
	[Field1privilege] [int] NULL,
	[Field2privilege] [int] NULL,
	[ParentId] [int] NULL,
	[Status] [int] NULL,
	[CDateTime] [datetime] NULL,
	[ProjectId] [int] NULL,
 CONSTRAINT [PK__tblUserp__E3DF0FDDAB6B9250] PRIMARY KEY CLUSTERED 
(
	[UserprivilegesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUserType]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserType](
	[UserTypeId] [int] IDENTITY(1,1) NOT NULL,
	[UserType] [nvarchar](256) NULL,
	[Status] [int] NULL,
	[cDateTime] [datetime] NULL,
 CONSTRAINT [PK__tblUserT__40D2D816D5C4166C] PRIMARY KEY CLUSTERED 
(
	[UserTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TeamManage]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TeamManage](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Category] [nvarchar](255) NULL,
	[Team] [nvarchar](255) NULL,
	[Developer] [nvarchar](255) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](255) NULL,
	[Status] [bit] NULL,
 CONSTRAINT [PK_TeamManage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TeamMapping]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TeamMapping](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Team_FK_Id] [bigint] NULL,
	[Login_FK_Id] [bigint] NULL,
	[Category] [nvarchar](255) NULL,
 CONSTRAINT [PK_TeamMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [UserManagement].[NavigationMenus]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UserManagement].[NavigationMenus](
	[Id] [tinyint] IDENTITY(1,1) NOT NULL,
	[ParentID] [tinyint] NULL,
	[MenuName] [varchar](128) NOT NULL,
	[MenuUrl] [nvarchar](256) NULL,
	[MenuIcon] [nvarchar](128) NULL,
	[IsActive] [bit] NOT NULL,
	[SortOrder] [nvarchar](50) NOT NULL,
	[Type] [tinyint] NULL,
 CONSTRAINT [PK_NavigationMenus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [UserManagement].[PrivilegeActions]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UserManagement].[PrivilegeActions](
	[Id] [tinyint] IDENTITY(1,1) NOT NULL,
	[Privilege] [varchar](64) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_PrivilegeActions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [UserManagement].[RolesPrivileges]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UserManagement].[RolesPrivileges](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RolesFkId] [uniqueidentifier] NOT NULL,
	[NavigationMenusFkId] [tinyint] NOT NULL,
	[PrivilegeActionsFkId] [tinyint] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_RolesPrivileges] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [UserManagement].[UserPrivileges]    Script Date: 01-11-2023 16:48:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UserManagement].[UserPrivileges](
	[Id] [uniqueidentifier] NOT NULL,
	[NavigationMenusFkId] [int] NOT NULL,
	[PrivilegeActionsFkId] [int] NOT NULL,
	[UsersFkId] [uniqueidentifier] NOT NULL,
	[IsTrue] [bit] NULL,
	[IsGranted] [bit] NULL,
	[IsDeny] [bit] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_UMUserPrivileges] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[AspNetRoles] ([Id], [ConcurrencyStamp], [Name], [NormalizedName], [Description], [RoleType], [IsPrimary], [IsEditable], [IsDeleted], [IsAdminRole], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate], [RoleName], [IsActive], [SortOrder]) VALUES (N'bf7dd010-4396-4cf4-9df7-0075c9b2dac8', N'3badd2b3-5e7d-4e65-8efc-7d46d8426c74', N'sa', N'SA', N'SA -> Super Admin Role. Role is for Super Admin to control entire system.(Super Admin Website Users)', 1, 1, 0, 0, 1, N'42e4347a-133e-4190-b1e2-bf8d656b6216', N'42e4347a-133e-4190-b1e2-bf8d656b6216', CAST(N'2020-05-15T18:03:06.583' AS DateTime), CAST(N'2020-05-15T18:03:06.583' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [ConcurrencyStamp], [Name], [NormalizedName], [Description], [RoleType], [IsPrimary], [IsEditable], [IsDeleted], [IsAdminRole], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate], [RoleName], [IsActive], [SortOrder]) VALUES (N'b0c6046d-78cb-4d11-ea82-08db9a411e49', N'c7612351-38ff-4e2f-b66a-d1370a9652ee', N'User', N'USER', N'Test', 4, 0, 1, 0, 0, N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-08-11T08:01:07.480' AS DateTime), CAST(N'2023-10-19T11:19:31.510' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [ConcurrencyStamp], [Name], [NormalizedName], [Description], [RoleType], [IsPrimary], [IsEditable], [IsDeleted], [IsAdminRole], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate], [RoleName], [IsActive], [SortOrder]) VALUES (N'a64b4287-bcd6-426f-bd06-14fea4f859e1', N'3672a038-1c83-4456-9c87-eb882be2f196', N'Admin', N'ADMIN', N'Admin Agent', 4, 0, 0, 0, 0, N'42e4347a-133e-4190-b1e2-bf8d656b6216', N'00000000-0000-0000-0000-000000000000', CAST(N'2020-05-15T18:00:52.797' AS DateTime), CAST(N'2023-10-19T11:19:19.317' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [ConcurrencyStamp], [Name], [NormalizedName], [Description], [RoleType], [IsPrimary], [IsEditable], [IsDeleted], [IsAdminRole], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate], [RoleName], [IsActive], [SortOrder]) VALUES (N'b8d6ee5c-9a8f-4829-b210-73a776de3e42', N'5439d111-1da1-4d10-a2ac-e24bc51a6d3f', N'st', N'ST', N'Startups Login', 2, 0, 0, 0, 0, N'42e4347a-133e-4190-b1e2-bf8d656b6216', N'42e4347a-133e-4190-b1e2-bf8d656b6216', CAST(N'2020-05-15T18:00:52.797' AS DateTime), CAST(N'2020-05-15T18:00:52.797' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[AspNetUserClaims] ON 

INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (1, N'sub', N'978ac6e8-cc12-42a0-0928-08db65aadd90', N'978ac6e8-cc12-42a0-0928-08db65aadd90')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (2, N'fullName', N'super admin', N'978ac6e8-cc12-42a0-0928-08db65aadd90')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (3, N'userName', N'sa@intigate.in', N'978ac6e8-cc12-42a0-0928-08db65aadd90')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (4, N'name', N'SA@INTIGATE.IN', N'978ac6e8-cc12-42a0-0928-08db65aadd90')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (5, N'email', N'sa@intigate.in', N'978ac6e8-cc12-42a0-0928-08db65aadd90')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (6, N'phone', N'8826343311', N'978ac6e8-cc12-42a0-0928-08db65aadd90')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (7, N'enterprise', N'd2b717ca-dfb6-497e-65af-08db65aadd5c', N'978ac6e8-cc12-42a0-0928-08db65aadd90')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (8, N'verifiedEmail', N'False', N'978ac6e8-cc12-42a0-0928-08db65aadd90')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (9, N'verifiedPhone', N'False', N'978ac6e8-cc12-42a0-0928-08db65aadd90')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (10, N'idp', N'CT.AspNetCore.IdentityService', N'978ac6e8-cc12-42a0-0928-08db65aadd90')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (11, N'auth_time', N'1685958873', N'978ac6e8-cc12-42a0-0928-08db65aadd90')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (12, N'iat', N'1685958873', N'978ac6e8-cc12-42a0-0928-08db65aadd90')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (661, N'sub', N'd05635ae-45bd-4842-44db-08dba3c49927', N'd05635ae-45bd-4842-44db-08dba3c49927')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (662, N'fullName', N'Shaukeen khan', N'd05635ae-45bd-4842-44db-08dba3c49927')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (663, N'userName', N'shaukeen@intigate.in', N'd05635ae-45bd-4842-44db-08dba3c49927')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (664, N'name', N'shaukeen@intigate.in', N'd05635ae-45bd-4842-44db-08dba3c49927')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (665, N'email', N'shaukeen@intigate.in', N'd05635ae-45bd-4842-44db-08dba3c49927')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (666, N'phone', N'88996 65544', N'd05635ae-45bd-4842-44db-08dba3c49927')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (667, N'verifiedEmail', N'False', N'd05635ae-45bd-4842-44db-08dba3c49927')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (668, N'verifiedPhone', N'False', N'd05635ae-45bd-4842-44db-08dba3c49927')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (669, N'idp', N'CT.AspNetCore.IdentityService', N'd05635ae-45bd-4842-44db-08dba3c49927')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (670, N'auth_time', N'1692786898', N'd05635ae-45bd-4842-44db-08dba3c49927')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (671, N'iat', N'1692786898', N'd05635ae-45bd-4842-44db-08dba3c49927')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (672, N'adminusers', N'd05635ae-45bd-4842-44db-08dba3c49927', N'd05635ae-45bd-4842-44db-08dba3c49927')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (733, N'sub', N'58bf42ee-3012-49bd-5640-08dbb35269e3', N'58bf42ee-3012-49bd-5640-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (734, N'fullName', N'Ben Duck', N'58bf42ee-3012-49bd-5640-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (735, N'userName', N'ben.duck@gmail.com', N'58bf42ee-3012-49bd-5640-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (736, N'name', N'BEN.DUCK@GMAIL.COM', N'58bf42ee-3012-49bd-5640-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (737, N'email', N'ben.duck@gmail.com', N'58bf42ee-3012-49bd-5640-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (738, N'phone', N'78541 25639', N'58bf42ee-3012-49bd-5640-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (739, N'verifiedEmail', N'False', N'58bf42ee-3012-49bd-5640-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (740, N'verifiedPhone', N'False', N'58bf42ee-3012-49bd-5640-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (741, N'idp', N'CT.AspNetCore.IdentityService', N'58bf42ee-3012-49bd-5640-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (742, N'auth_time', N'1694497226', N'58bf42ee-3012-49bd-5640-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (743, N'iat', N'1694497226', N'58bf42ee-3012-49bd-5640-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (744, N'startups', N'e28ad447-192a-4b4d-4871-08dbb3519ee6', N'58bf42ee-3012-49bd-5640-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (745, N'sub', N'1016608e-9980-480d-5641-08dbb35269e3', N'1016608e-9980-480d-5641-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (746, N'fullName', N'Razi Hussain', N'1016608e-9980-480d-5641-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (747, N'userName', N'hussain@Razi.com', N'1016608e-9980-480d-5641-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (748, N'name', N'HUSSAIN@RAZI.COM', N'1016608e-9980-480d-5641-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (749, N'email', N'hussain@Razi.com', N'1016608e-9980-480d-5641-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (750, N'phone', N'82731 98241', N'1016608e-9980-480d-5641-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (751, N'verifiedEmail', N'False', N'1016608e-9980-480d-5641-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (752, N'verifiedPhone', N'False', N'1016608e-9980-480d-5641-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (753, N'idp', N'CT.AspNetCore.IdentityService', N'1016608e-9980-480d-5641-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (754, N'auth_time', N'1694497230', N'1016608e-9980-480d-5641-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (755, N'iat', N'1694497230', N'1016608e-9980-480d-5641-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (756, N'startups', N'cffbc4db-d367-4976-4870-08dbb3519ee6', N'1016608e-9980-480d-5641-08dbb35269e3')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (757, N'sub', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (758, N'fullName', N'Mohd Razi', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (759, N'userName', N'mohd.razi@intigate.in', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (760, N'name', N'mohd.razi@intigate.in', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (761, N'email', N'mohd.razi@intigate.in', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (762, N'phone', N'82731 98220', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (763, N'verifiedEmail', N'False', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (764, N'verifiedPhone', N'False', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (765, N'idp', N'CT.AspNetCore.IdentityService', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (766, N'auth_time', N'1697528653', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (767, N'iat', N'1697528653', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (768, N'adminusers', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (769, N'sub', N'268d192e-372e-433e-5051-08dbcef64187', N'268d192e-372e-433e-5051-08dbcef64187')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (770, N'fullName', N'Razi Hussain', N'268d192e-372e-433e-5051-08dbcef64187')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (771, N'userName', N'abc@gmail.com', N'268d192e-372e-433e-5051-08dbcef64187')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (772, N'name', N'abc@gmail.com', N'268d192e-372e-433e-5051-08dbcef64187')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (773, N'email', N'abc@gmail.com', N'268d192e-372e-433e-5051-08dbcef64187')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (774, N'phone', N'85455 45454', N'268d192e-372e-433e-5051-08dbcef64187')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (775, N'verifiedEmail', N'False', N'268d192e-372e-433e-5051-08dbcef64187')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (776, N'verifiedPhone', N'False', N'268d192e-372e-433e-5051-08dbcef64187')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (777, N'idp', N'CT.AspNetCore.IdentityService', N'268d192e-372e-433e-5051-08dbcef64187')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (778, N'auth_time', N'1697536126', N'268d192e-372e-433e-5051-08dbcef64187')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (779, N'iat', N'1697536126', N'268d192e-372e-433e-5051-08dbcef64187')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (780, N'adminusers', N'268d192e-372e-433e-5051-08dbcef64187', N'268d192e-372e-433e-5051-08dbcef64187')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (793, N'sub', N'ead40264-131d-4829-610f-08dbda0130a9', N'ead40264-131d-4829-610f-08dbda0130a9')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (794, N'fullName', N'tester testing', N'ead40264-131d-4829-610f-08dbda0130a9')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (795, N'userName', N'asdasd@gmail.com', N'ead40264-131d-4829-610f-08dbda0130a9')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (796, N'name', N'asdasd@gmail.com', N'ead40264-131d-4829-610f-08dbda0130a9')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (797, N'email', N'asdasd@gmail.com', N'ead40264-131d-4829-610f-08dbda0130a9')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (798, N'phone', N'85858 58585', N'ead40264-131d-4829-610f-08dbda0130a9')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (799, N'verifiedEmail', N'False', N'ead40264-131d-4829-610f-08dbda0130a9')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (800, N'verifiedPhone', N'False', N'ead40264-131d-4829-610f-08dbda0130a9')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (801, N'idp', N'CT.AspNetCore.IdentityService', N'ead40264-131d-4829-610f-08dbda0130a9')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (802, N'auth_time', N'1698750285', N'ead40264-131d-4829-610f-08dbda0130a9')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (803, N'iat', N'1698750285', N'ead40264-131d-4829-610f-08dbda0130a9')
INSERT [dbo].[AspNetUserClaims] ([Id], [ClaimType], [ClaimValue], [UserId]) VALUES (804, N'adminusers', N'ead40264-131d-4829-610f-08dbda0130a9', N'ead40264-131d-4829-610f-08dbda0130a9')
SET IDENTITY_INSERT [dbo].[AspNetUserClaims] OFF
GO
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'978ac6e8-cc12-42a0-0928-08db65aadd90', N'bf7dd010-4396-4cf4-9df7-0075c9b2dac8')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'd05635ae-45bd-4842-44db-08dba3c49927', N'a64b4287-bcd6-426f-bd06-14fea4f859e1')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'58bf42ee-3012-49bd-5640-08dbb35269e3', N'b8d6ee5c-9a8f-4829-b210-73a776de3e42')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'1016608e-9980-480d-5641-08dbb35269e3', N'b8d6ee5c-9a8f-4829-b210-73a776de3e42')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55', N'a64b4287-bcd6-426f-bd06-14fea4f859e1')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'268d192e-372e-433e-5051-08dbcef64187', N'a64b4287-bcd6-426f-bd06-14fea4f859e1')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'ead40264-131d-4829-610f-08dbda0130a9', N'a64b4287-bcd6-426f-bd06-14fea4f859e1')
GO
INSERT [dbo].[AspNetUsers] ([Id], [UserType], [AccessFailedCount], [ConcurrencyStamp], [FullName], [UserName], [FirstName], [LastName], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [CountryCode], [UserStatus], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'978ac6e8-cc12-42a0-0928-08db65aadd90', 1, 0, N'df1f659d-8574-4e3a-8a65-9df52e19358a', N'super admin', N'sa@intigate.in', N'super', N'admin', N'sa@intigate.in', 1, 1, NULL, N'SA@INTIGATE.IN', N'SA@INTIGATE.IN', N'AQAAAAEAAMNQAAAAEJ/6mZEzFPr4JDnSg1C2S1tpSxmREIgUE+x5eD4pebrCxoYfwDPZWchDxr4CoyZAdQ==', N'8826343311', 1, N'L2CSKE3B4LLBNG7YF375LHY7GH3PGZRN', 0, N'+91', 1, N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-06-05T09:54:33.943' AS DateTime), CAST(N'2023-10-31T11:02:03.940' AS DateTime))
INSERT [dbo].[AspNetUsers] ([Id], [UserType], [AccessFailedCount], [ConcurrencyStamp], [FullName], [UserName], [FirstName], [LastName], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [CountryCode], [UserStatus], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'd05635ae-45bd-4842-44db-08dba3c49927', 4, 0, N'23d1231c-d3bc-4810-b8cd-8778b2314709', N'Shaukeen khan', N'shaukeen@intigate.in', N'Shaukeen', N'khan', N'shaukeen@intigate.in', 0, 1, NULL, N'SHAUKEEN@INTIGATE.IN', N'SHAUKEEN@INTIGATE.IN', N'AQAAAAEAAMNQAAAAEBYu9qHHlRfDCqjvHCms/Tm9cpFC+uBReh+HYumYZRypwHAwcV3L+e6Jy5igU2W5rw==', N'88996 65544', 0, N'VDQP4P6GS5UUK4OFWBSESTJLO7FEYPE5', 0, N'+91', 1, N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-08-23T10:34:58.223' AS DateTime), CAST(N'2023-08-25T11:06:34.350' AS DateTime))
INSERT [dbo].[AspNetUsers] ([Id], [UserType], [AccessFailedCount], [ConcurrencyStamp], [FullName], [UserName], [FirstName], [LastName], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [CountryCode], [UserStatus], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'1dc98fe8-98e5-48f1-3385-08dbb34dece1', 2, 0, N'484d3e2b-0254-41b7-b6eb-bfef22a67045', N'dfbghsdfbg dfgsdfg', N'dfgsdfgsdfg@gmail.com', N'dfbghsdfbg', N'dfgsdfg', N'dfgsdfgsdfg@gmail.com', 0, 1, NULL, N'DFGSDFGSDFG@GMAIL.COM', N'DFGSDFGSDFG@GMAIL.COM', N'AQAAAAEAAMNQAAAAECK7jGK3onKeEZz0Qw1HnoJcdVpuvooln0P3bf6xtxTQZgzzXd9SKprp5YjLApo6Pg==', N'82731 98220', 0, N'M3YZNR4AHLWH4KGE2HYVAQ6WGIWSRFRE', 0, N'+91', 0, N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-09-12T05:13:48.463' AS DateTime), CAST(N'2023-09-12T05:13:48.463' AS DateTime))
INSERT [dbo].[AspNetUsers] ([Id], [UserType], [AccessFailedCount], [ConcurrencyStamp], [FullName], [UserName], [FirstName], [LastName], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [CountryCode], [UserStatus], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'672a85c9-e26c-4317-3386-08dbb34dece1', 2, 0, N'41fa6e64-3db1-4dd1-9886-7105e3ca2643', N'Ben  Duck', N'ben@gmail.com', N'Ben ', N'Duck', N'ben@gmail.com', 0, 1, NULL, N'BEN@GMAIL.COM', N'BEN@GMAIL.COM', N'AQAAAAEAAMNQAAAAENx2OWV2I7ZvoE2ZhXWRjJJFdIiFUSLFIIv6ijUbD3KGibl3R7AMSw8DnAa08luhDg==', N'84502 13550', 0, N'LRY3COFUSIIPNLMGGCXWIWZN56FCUVDJ', 0, N'+91', 0, N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-09-12T05:15:38.670' AS DateTime), CAST(N'2023-09-12T05:15:38.670' AS DateTime))
INSERT [dbo].[AspNetUsers] ([Id], [UserType], [AccessFailedCount], [ConcurrencyStamp], [FullName], [UserName], [FirstName], [LastName], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [CountryCode], [UserStatus], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'58bf42ee-3012-49bd-5640-08dbb35269e3', 2, 0, N'4bce353a-1aed-4dd8-998c-1d901cd92473', N'Ben Duck', N'ben.duck@gmail.com', N'Ben', N'Duck', N'ben.duck@gmail.com', 0, 1, NULL, N'BEN.DUCK@GMAIL.COM', N'BEN.DUCK@GMAIL.COM', N'AQAAAAEAAMNQAAAAEK7QgpuJ0rmNZwP6t673TkGQ2nFSJNGzsjqABVG0l5y186lsf8j1spDHq1kJjHPJ3Q==', N'78541 25639', 0, N'OY3E5EIUEWOS6IG7GYDGWE3FCL7NEC3D', 0, N'+91', 0, N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-09-12T05:40:26.717' AS DateTime), CAST(N'2023-09-12T05:40:26.750' AS DateTime))
INSERT [dbo].[AspNetUsers] ([Id], [UserType], [AccessFailedCount], [ConcurrencyStamp], [FullName], [UserName], [FirstName], [LastName], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [CountryCode], [UserStatus], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'1016608e-9980-480d-5641-08dbb35269e3', 2, 0, N'2d7538b2-4aa7-4c0c-a628-d1c0dc7a969c', N'Razi Hussain', N'hussain@Razi.com', N'Razi', N'Hussain', N'hussain@Razi.com', 0, 1, NULL, N'HUSSAIN@RAZI.COM', N'HUSSAIN@RAZI.COM', N'AQAAAAEAAMNQAAAAEGnwDQ/Prn7E9JyVJ/DAMRBaSUqYJg4uT5johaNMZp4Ow2m6oBdVzRaS/rqfsGzJFg==', N'82731 98241', 0, N'I3BXITTRDBYEUT5MV6NJIZXVVXII74FE', 0, N'+91', 0, N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-09-12T05:40:30.467' AS DateTime), CAST(N'2023-09-12T05:40:30.497' AS DateTime))
INSERT [dbo].[AspNetUsers] ([Id], [UserType], [AccessFailedCount], [ConcurrencyStamp], [FullName], [UserName], [FirstName], [LastName], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [CountryCode], [UserStatus], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55', 4, 0, N'1691792d-0a78-4a21-b6c2-bf79cd480237', N'Mohd Razi', N'mohd.razi@intigate.in', N'Mohd', N'Razi', N'mohd.razi@intigate.in', 0, 1, NULL, N'MOHD.RAZI@INTIGATE.IN', N'MOHD.RAZI@INTIGATE.IN', N'AQAAAAEAAMNQAAAAECCiCtqi5TajMqbwxmnvBfPHpUuvW4+qtfwi3FY+GOacQIngXBruE3HPDRzz8UcJig==', N'82731 98220', 0, N'JZZY32ZULZHBPIZGSID7OIBHOJZCTKQP', 0, N'+91', 1, N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-10-17T07:44:13.100' AS DateTime), CAST(N'2023-10-17T07:44:13.367' AS DateTime))
INSERT [dbo].[AspNetUsers] ([Id], [UserType], [AccessFailedCount], [ConcurrencyStamp], [FullName], [UserName], [FirstName], [LastName], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [CountryCode], [UserStatus], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'268d192e-372e-433e-5051-08dbcef64187', 4, 0, N'9d7bc4e9-3093-4f39-8770-d6b9990f0006', N'Razi Hussain', N'abc@gmail.com', N'Razi', N'Hussain', N'abc@gmail.com', 0, 1, NULL, N'ABC@GMAIL.COM', N'ABC@GMAIL.COM', N'AQAAAAEAAMNQAAAAEJacp/eT+Tj4xzdypvIbmHkQz6UprTw/zQgMY42mp6FnecxIPuMttwbID1hTVfirBA==', N'85455 45454', 0, N'QR4UNGUKH3HYPJ6LU5YPJQDWMXJYBDWA', 0, NULL, 1, N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-10-17T09:48:46.083' AS DateTime), CAST(N'2023-10-30T10:33:23.080' AS DateTime))
INSERT [dbo].[AspNetUsers] ([Id], [UserType], [AccessFailedCount], [ConcurrencyStamp], [FullName], [UserName], [FirstName], [LastName], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [CountryCode], [UserStatus], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'ead40264-131d-4829-610f-08dbda0130a9', 4, 0, N'82124fc2-e7b2-44db-84e7-abf7f413c93b', N'tester testing', N'asdasd@gmail.com', N'tester', N'testing', N'asdasd@gmail.com', 0, 1, NULL, N'ASDASD@GMAIL.COM', N'ASDASD@GMAIL.COM', N'AQAAAAEAAMNQAAAAENyf1AsWc2m8ZBDGu6pnQHGM4kjlc6UbGpdkvoN0zoQ4S/fxvEH4dCiCbzGaKYdFiw==', N'85858 58585', 0, N'L6WNGUXQG7WE7XQJ5YOYG6WVI4C4HXPY', 0, N'+91', 1, N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-10-31T11:04:44.940' AS DateTime), CAST(N'2023-10-31T11:04:45.167' AS DateTime))
GO
INSERT [dbo].[AspNetUsersDetail] ([Id], [AspNetUsersFkId], [DeviceTypeFkId], [CryptoWalletAddress], [LastLoggedIn], [DefaultPasswordChanged], [ForceChangePassword], [LastChangePasswordDate], [WalletBalance], [ProfilePicture], [DOB], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'7975556d-9c90-457d-8a76-08db65aaddae', N'978ac6e8-cc12-42a0-0928-08db65aadd90', 0, NULL, CAST(N'2023-08-21T12:02:16.183' AS DateTime), 1, 0, CAST(N'2023-08-21T12:02:16.183' AS DateTime), NULL, NULL, CAST(N'2023-08-21T12:02:16.183' AS DateTime), N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-06-05T09:54:34.103' AS DateTime), CAST(N'2023-08-21T12:02:16.183' AS DateTime))
INSERT [dbo].[AspNetUsersDetail] ([Id], [AspNetUsersFkId], [DeviceTypeFkId], [CryptoWalletAddress], [LastLoggedIn], [DefaultPasswordChanged], [ForceChangePassword], [LastChangePasswordDate], [WalletBalance], [ProfilePicture], [DOB], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'08818cb6-6f26-4de3-7dc5-08dba3c49940', N'd05635ae-45bd-4842-44db-08dba3c49927', 0, NULL, CAST(N'2023-08-25T10:50:08.000' AS DateTime), 1, 0, CAST(N'2023-08-25T10:50:08.000' AS DateTime), NULL, NULL, CAST(N'2023-08-25T10:50:08.000' AS DateTime), N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-08-23T10:34:58.303' AS DateTime), CAST(N'2023-08-25T10:50:08.000' AS DateTime))
INSERT [dbo].[AspNetUsersDetail] ([Id], [AspNetUsersFkId], [DeviceTypeFkId], [CryptoWalletAddress], [LastLoggedIn], [DefaultPasswordChanged], [ForceChangePassword], [LastChangePasswordDate], [WalletBalance], [ProfilePicture], [DOB], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'8ff8831f-b24f-4159-decc-08dbb3529b62', N'58bf42ee-3012-49bd-5640-08dbb35269e3', 1, N'', CAST(N'2023-09-12T05:40:26.787' AS DateTime), 0, 0, CAST(N'2023-09-12T05:40:26.787' AS DateTime), NULL, N'', CAST(N'2023-09-12T05:40:26.787' AS DateTime), N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-09-12T05:40:26.787' AS DateTime), CAST(N'2023-09-12T05:40:26.787' AS DateTime))
INSERT [dbo].[AspNetUsersDetail] ([Id], [AspNetUsersFkId], [DeviceTypeFkId], [CryptoWalletAddress], [LastLoggedIn], [DefaultPasswordChanged], [ForceChangePassword], [LastChangePasswordDate], [WalletBalance], [ProfilePicture], [DOB], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'ba014d39-239d-47b9-decd-08dbb3529b62', N'1016608e-9980-480d-5641-08dbb35269e3', 1, N'', CAST(N'2023-09-12T05:40:30.533' AS DateTime), 0, 0, CAST(N'2023-09-12T05:40:30.533' AS DateTime), NULL, N'', CAST(N'2023-09-12T05:40:30.533' AS DateTime), N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-09-12T05:40:30.533' AS DateTime), CAST(N'2023-09-12T05:40:30.533' AS DateTime))
INSERT [dbo].[AspNetUsersDetail] ([Id], [AspNetUsersFkId], [DeviceTypeFkId], [CryptoWalletAddress], [LastLoggedIn], [DefaultPasswordChanged], [ForceChangePassword], [LastChangePasswordDate], [WalletBalance], [ProfilePicture], [DOB], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'a67fb6f9-1b07-4d06-83a2-08dbcee4db65', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55', 0, NULL, CAST(N'2023-10-17T13:14:13.167' AS DateTime), 0, 0, CAST(N'2023-10-17T13:14:13.167' AS DateTime), NULL, NULL, CAST(N'2023-10-17T13:14:13.167' AS DateTime), N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-10-17T13:14:13.167' AS DateTime), CAST(N'2023-10-17T13:14:13.167' AS DateTime))
INSERT [dbo].[AspNetUsersDetail] ([Id], [AspNetUsersFkId], [DeviceTypeFkId], [CryptoWalletAddress], [LastLoggedIn], [DefaultPasswordChanged], [ForceChangePassword], [LastChangePasswordDate], [WalletBalance], [ProfilePicture], [DOB], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'2ee98cfb-be12-4c91-cfa2-08dbcef641b0', N'268d192e-372e-433e-5051-08dbcef64187', 0, NULL, CAST(N'2023-10-17T15:18:46.233' AS DateTime), 0, 0, CAST(N'2023-10-17T15:18:46.233' AS DateTime), NULL, NULL, CAST(N'2023-10-17T15:18:46.233' AS DateTime), N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-10-17T15:18:46.233' AS DateTime), CAST(N'2023-10-17T15:18:46.233' AS DateTime))
INSERT [dbo].[AspNetUsersDetail] ([Id], [AspNetUsersFkId], [DeviceTypeFkId], [CryptoWalletAddress], [LastLoggedIn], [DefaultPasswordChanged], [ForceChangePassword], [LastChangePasswordDate], [WalletBalance], [ProfilePicture], [DOB], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate]) VALUES (N'd21cd8d2-9d16-4530-cd53-08dbda0130b4', N'ead40264-131d-4829-610f-08dbda0130a9', 0, NULL, CAST(N'2023-10-31T16:34:44.990' AS DateTime), 0, 0, CAST(N'2023-10-31T16:34:44.990' AS DateTime), NULL, NULL, CAST(N'2023-10-31T16:34:44.990' AS DateTime), N'00000000-0000-0000-0000-000000000000', N'00000000-0000-0000-0000-000000000000', CAST(N'2023-10-31T16:34:44.990' AS DateTime), CAST(N'2023-10-31T16:34:44.990' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[AspNetUsersStatus] ON 

INSERT [dbo].[AspNetUsersStatus] ([Id], [UserStatus]) VALUES (0, N'Inactive')
INSERT [dbo].[AspNetUsersStatus] ([Id], [UserStatus]) VALUES (1, N'Active')
INSERT [dbo].[AspNetUsersStatus] ([Id], [UserStatus]) VALUES (2, N'Deleted')
SET IDENTITY_INSERT [dbo].[AspNetUsersStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[AspNetUsersTypes] ON 

INSERT [dbo].[AspNetUsersTypes] ([Id], [UserType]) VALUES (1, N'Super Admin')
INSERT [dbo].[AspNetUsersTypes] ([Id], [UserType]) VALUES (2, N'StartUps')
INSERT [dbo].[AspNetUsersTypes] ([Id], [UserType]) VALUES (3, N'VC')
INSERT [dbo].[AspNetUsersTypes] ([Id], [UserType]) VALUES (4, N'Admin Agent')
INSERT [dbo].[AspNetUsersTypes] ([Id], [UserType]) VALUES (5, N'Admin Review')
SET IDENTITY_INSERT [dbo].[AspNetUsersTypes] OFF
GO
INSERT [dbo].[DummyPieChartData] ([Category], [Value]) VALUES (N'Category A', 25)
INSERT [dbo].[DummyPieChartData] ([Category], [Value]) VALUES (N'Category B', 40)
INSERT [dbo].[DummyPieChartData] ([Category], [Value]) VALUES (N'Category C', 15)
INSERT [dbo].[DummyPieChartData] ([Category], [Value]) VALUES (N'Category D', 20)
GO
SET IDENTITY_INSERT [dbo].[MST_Company] ON 

INSERT [dbo].[MST_Company] ([CompanyId], [Comp_Code], [Desc_Eng], [Desc_Arb], [Status], [cDateTime]) VALUES (1, 1, N'Eureka Trading', N'Eureka Trading', N'1', CAST(N'2014-11-16T12:03:21.733' AS DateTime))
INSERT [dbo].[MST_Company] ([CompanyId], [Comp_Code], [Desc_Eng], [Desc_Arb], [Status], [cDateTime]) VALUES (2, 2, N'Eureka Mobile', N'E-Mobile', N'1', CAST(N'2014-11-16T12:03:21.733' AS DateTime))
INSERT [dbo].[MST_Company] ([CompanyId], [Comp_Code], [Desc_Eng], [Desc_Arb], [Status], [cDateTime]) VALUES (3, 3, N'Square Distribution', N'Square Distribution', N'1', CAST(N'2014-11-16T12:03:21.733' AS DateTime))
INSERT [dbo].[MST_Company] ([CompanyId], [Comp_Code], [Desc_Eng], [Desc_Arb], [Status], [cDateTime]) VALUES (4, 4, N'E-Fashion', N'E-Fashion', N'1', CAST(N'2014-11-16T12:03:21.733' AS DateTime))
INSERT [dbo].[MST_Company] ([CompanyId], [Comp_Code], [Desc_Eng], [Desc_Arb], [Status], [cDateTime]) VALUES (5, 5, N'EDAM GROUP-RESTAURAN', N'EDAM GROUP-RESTAURAN', N'1', CAST(N'2014-11-16T12:03:21.733' AS DateTime))
INSERT [dbo].[MST_Company] ([CompanyId], [Comp_Code], [Desc_Eng], [Desc_Arb], [Status], [cDateTime]) VALUES (6, 6, N'EDAM GROUP-ENTERTAIN', N'EDAM GROUP-ENTERTAIN', N'1', CAST(N'2014-11-16T12:03:21.733' AS DateTime))
SET IDENTITY_INSERT [dbo].[MST_Company] OFF
GO
SET IDENTITY_INSERT [dbo].[MT_ProjectCategory] ON 

INSERT [dbo].[MT_ProjectCategory] ([Id], [Name]) VALUES (1, N'Hardware')
INSERT [dbo].[MT_ProjectCategory] ([Id], [Name]) VALUES (2, N'Software')
INSERT [dbo].[MT_ProjectCategory] ([Id], [Name]) VALUES (3, N'Construction')
INSERT [dbo].[MT_ProjectCategory] ([Id], [Name]) VALUES (4, N'Retail')
INSERT [dbo].[MT_ProjectCategory] ([Id], [Name]) VALUES (5, N'Operators')
SET IDENTITY_INSERT [dbo].[MT_ProjectCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[MT_ProjectStatus] ON 

INSERT [dbo].[MT_ProjectStatus] ([Id], [Name]) VALUES (1, N'Not Started')
INSERT [dbo].[MT_ProjectStatus] ([Id], [Name]) VALUES (2, N'In Progress')
INSERT [dbo].[MT_ProjectStatus] ([Id], [Name]) VALUES (3, N'Completed')
INSERT [dbo].[MT_ProjectStatus] ([Id], [Name]) VALUES (20, N'Pending')
SET IDENTITY_INSERT [dbo].[MT_ProjectStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[PMS_MASTER_TABLE] ON 

INSERT [dbo].[PMS_MASTER_TABLE] ([ID], [NAME]) VALUES (1, N'PROJECT CATEGORY')
INSERT [dbo].[PMS_MASTER_TABLE] ([ID], [NAME]) VALUES (2, N'PROJECT STATUS')
INSERT [dbo].[PMS_MASTER_TABLE] ([ID], [NAME]) VALUES (3, N'TEAM MANAGE')
SET IDENTITY_INSERT [dbo].[PMS_MASTER_TABLE] OFF
GO
SET IDENTITY_INSERT [dbo].[tblProject] ON 

INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (52, NULL, 1, NULL, NULL, 12497, N'2', N'Wedding Application (web)', CAST(N'2023-10-20T00:00:00.000' AS DateTime), CAST(N'2023-11-01T00:00:00.000' AS DateTime), CAST(N'2023-11-18T00:00:00.000' AS DateTime), 75, 52, 10780, NULL, N'Wedding Application web version.', NULL, 10607, NULL, N'', NULL, N'978ac6e8-cc12-42a0-0928-08db65aadd90', N'268d192e-372e-433e-5051-08dbcef64187', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55', 2)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (73, NULL, 1, NULL, NULL, 12993, N'Software', N'POS new invoice printing for 40 cms', CAST(N'2021-06-10T00:00:00.000' AS DateTime), CAST(N'2021-10-31T00:00:00.000' AS DateTime), CAST(N'2001-01-01T00:00:00.000' AS DateTime), 10, 53, 10780, NULL, N'Each invoice should print in multiples of 40 cms', NULL, 10607, NULL, N'', NULL, NULL, NULL, NULL, 3)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (74, NULL, 1, NULL, NULL, 12406, N'Software', N'New Receipt of goods report', CAST(N'2021-06-25T00:00:00.000' AS DateTime), CAST(N'2021-08-16T00:00:00.000' AS DateTime), CAST(N'2001-01-01T00:00:00.000' AS DateTime), 100, 53, 10780, NULL, N'Receipts of good to be linked with delivery note', 1, 10607, NULL, N'', NULL, NULL, NULL, NULL, 2)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (75, NULL, 1, NULL, NULL, 12497, N'Software', N'eCommerce - Digital Marketing tasks', CAST(N'2021-09-26T00:00:00.000' AS DateTime), CAST(N'2021-10-05T00:00:00.000' AS DateTime), CAST(N'2001-01-01T00:00:00.000' AS DateTime), 100, 53, 10780, NULL, N'Upload of the form feed file on an hourly basis', 1, 10607, NULL, N'', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (76, NULL, 1, NULL, NULL, 12497, N'Software', N'eCommerce - Increasing the banner size', CAST(N'2021-04-27T00:00:00.000' AS DateTime), CAST(N'2021-09-27T00:00:00.000' AS DateTime), CAST(N'2001-01-01T00:00:00.000' AS DateTime), 100, 53, 10780, NULL, N'Increase the mid banner and small banner size in website and mobile apps', 1, 10607, NULL, N'rakeshkumar.intigate@gmail.com', NULL, NULL, NULL, NULL, 3)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (77, NULL, 1, NULL, NULL, 12497, N'Software', N'eCommerce - Admin changes', CAST(N'2021-09-29T00:00:00.000' AS DateTime), CAST(N'2021-10-10T00:00:00.000' AS DateTime), CAST(N'2001-01-01T00:00:00.000' AS DateTime), 2, 53, 10780, NULL, N'Adding Amerzan Express payment method in the Orders screen', NULL, 10607, NULL, N'', NULL, NULL, NULL, NULL, 20)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (78, NULL, 1, NULL, NULL, 1, N'Hardware', N'KEMS Network upgrade', CAST(N'2021-06-02T00:00:00.000' AS DateTime), CAST(N'2021-06-19T00:00:00.000' AS DateTime), CAST(N'2001-01-01T00:00:00.000' AS DateTime), 75, 54, 10709, NULL, N'KEMS Network upgrade and backup installation', NULL, 10607, NULL, N'', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (82, NULL, 1, NULL, NULL, 10606, N'Software', N'Eurekar', CAST(N'2021-09-20T00:00:00.000' AS DateTime), CAST(N'2021-09-23T00:00:00.000' AS DateTime), CAST(N'2021-10-20T00:00:00.000' AS DateTime), 100, 53, 10789, NULL, N'-Profit Discount ,the invoice will show all the installments covered
-Change expenses Percentage calculations (in Follow up Screen)  should be from Total Contract Balance', 10789, 10607, NULL, N'', NULL, NULL, NULL, NULL, 3)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (83, NULL, 1, NULL, NULL, 10605, N'Software', N'Ecredit New - Sales', CAST(N'2021-03-01T00:00:00.000' AS DateTime), CAST(N'2021-09-25T00:00:00.000' AS DateTime), CAST(N'2021-10-20T00:00:00.000' AS DateTime), 100, 53, 10789, NULL, N'Sales Departmaent', 10789, 10607, NULL, N'', NULL, NULL, NULL, NULL, 3)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (84, NULL, 1, NULL, NULL, 10606, N'Software', N'Ecredit New - Installments', CAST(N'2021-08-02T00:00:00.000' AS DateTime), CAST(N'2021-11-15T00:00:00.000' AS DateTime), CAST(N'2021-10-20T00:00:00.000' AS DateTime), 100, 53, 10789, NULL, N'Installments Departnment', 10789, 10607, NULL, N'', NULL, NULL, NULL, NULL, 2)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (85, NULL, 1, NULL, NULL, 12993, N'Software', N'CRM', CAST(N'2021-07-06T00:00:00.000' AS DateTime), CAST(N'2021-10-30T00:00:00.000' AS DateTime), CAST(N'2023-10-26T00:00:00.000' AS DateTime), 88, 53, 10789, NULL, N'Customer Loyalty System', NULL, 10607, NULL, N'', NULL, NULL, NULL, NULL, 2)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (86, NULL, 1, NULL, NULL, 10607, N'Hardware', N'IT Audit Year of 2020', CAST(N'2021-04-04T00:00:00.000' AS DateTime), CAST(N'2021-10-11T00:00:00.000' AS DateTime), CAST(N'2021-10-11T00:00:00.000' AS DateTime), 100, 54, 10704, NULL, N'Year End Audit process', NULL, 10607, NULL, N'', NULL, NULL, NULL, NULL, 3)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (87, NULL, 1, NULL, NULL, 12477, N'Hardware', N'Jahra Service Center relocated', CAST(N'2021-10-10T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2001-01-01T00:00:00.000' AS DateTime), 50, 54, 10704, NULL, N'Service Center relocated', NULL, 10607, NULL, N'', NULL, NULL, NULL, NULL, 2)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (88, NULL, 1, NULL, NULL, 12553, N'Hardware', N'CCTV requirements for Salmiya showroom', CAST(N'2021-04-24T00:00:00.000' AS DateTime), CAST(N'2021-09-16T00:00:00.000' AS DateTime), CAST(N'2001-01-01T00:00:00.000' AS DateTime), 100, 54, 10704, NULL, N'Total camera’s needed,
13 old camera’s to be replaced by new ones
10 New camera’s to be installed from the new ones
Including voice', 10704, 10607, NULL, N'it@eureka.com.kw', NULL, NULL, NULL, NULL, 3)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (89, NULL, 1, NULL, NULL, 13768, N'Hardware', N'Required voice camera in Insurance Office', CAST(N'2021-09-29T00:00:00.000' AS DateTime), CAST(N'2021-10-29T00:00:00.000' AS DateTime), CAST(N'2001-01-01T00:00:00.000' AS DateTime), 100, 54, 10704, NULL, N'Install new voice camera in insurance camera', 10704, 10607, NULL, N'it@eureka.com.kw', NULL, NULL, NULL, NULL, 3)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (90, NULL, 5, NULL, NULL, 12772, N'Hardware', N'Rtest13102021', CAST(N'2021-10-16T00:00:00.000' AS DateTime), CAST(N'2021-10-20T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), 33, 54, 10704, NULL, N'Rktestdesc 13102021', 1, 12772, NULL, N'', NULL, NULL, NULL, NULL, 3)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (91, NULL, 2, NULL, NULL, 12772, N'Software', N'Testrk', CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2021-10-29T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), 66, 46, NULL, NULL, N'testrk desc', 1, 12772, NULL, N'', NULL, NULL, NULL, NULL, 20)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (92, NULL, 6, NULL, NULL, 12316, N'Hardware', N'Test', CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2021-10-29T00:00:00.000' AS DateTime), CAST(N'2001-01-01T00:00:00.000' AS DateTime), 66, 54, NULL, NULL, N'sddd', 1, 12772, NULL, N'', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (94, NULL, 4, NULL, NULL, 12316, N'Hardware', N'Test', CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2001-01-01T00:00:00.000' AS DateTime), 5, 54, NULL, NULL, N'trew', NULL, 12772, NULL, N'', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (95, NULL, 4, NULL, NULL, 12772, N'Software', N'PMS', CAST(N'2021-10-22T00:00:00.000' AS DateTime), CAST(N'2021-10-31T00:00:00.000' AS DateTime), CAST(N'2001-01-01T00:00:00.000' AS DateTime), NULL, 53, 10780, NULL, N'dssdf', NULL, 12772, NULL, N'', NULL, NULL, NULL, NULL, 3)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (96, NULL, 6, NULL, NULL, 12772, N'Software', N'Tessst', CAST(N'2021-10-19T00:00:00.000' AS DateTime), CAST(N'2021-10-31T00:00:00.000' AS DateTime), NULL, 0, 53, 10780, CAST(N'2021-10-17T13:02:10.487' AS DateTime), N'dfg', NULL, 12316, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (99, NULL, 5, NULL, NULL, 12772, N'Hardware', N'Testrk18102021', CAST(N'2021-10-19T00:00:00.000' AS DateTime), CAST(N'2021-10-28T00:00:00.000' AS DateTime), NULL, 25, 53, NULL, CAST(N'2021-10-18T09:09:16.430' AS DateTime), N'desc', 1, 12772, 71918, NULL, N'benefit tblproject', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (101, NULL, 4, NULL, NULL, 13106, N'Software', N'123', CAST(N'2021-10-19T00:00:00.000' AS DateTime), CAST(N'2021-10-23T00:00:00.000' AS DateTime), NULL, 0, 55, NULL, CAST(N'2021-10-18T13:47:20.080' AS DateTime), N'123', 1, 13796, 71929, NULL, N'123', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (103, NULL, 4, NULL, NULL, 12316, N'Software', N'TEST1234', CAST(N'2021-10-20T00:00:00.000' AS DateTime), CAST(N'2021-10-27T00:00:00.000' AS DateTime), NULL, 0, 55, NULL, CAST(N'2021-10-18T14:29:09.927' AS DateTime), N'TEST1234', 1, 12316, 71933, NULL, N'TEST1234', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (104, NULL, 1, NULL, NULL, 13002, N'Software', N'Faims Update Payroll', CAST(N'2021-10-06T00:00:00.000' AS DateTime), CAST(N'2021-10-21T00:00:00.000' AS DateTime), CAST(N'2021-10-18T14:40:57.713' AS DateTime), 100, 53, 10789, CAST(N'2021-10-18T14:39:34.317' AS DateTime), N'Faims Update Payroll', 1, 10607, 71934, NULL, N'to update the payrol', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (105, NULL, 6, NULL, NULL, 12772, N'Hardware', N'Testrk19102021', CAST(N'2021-10-19T00:00:00.000' AS DateTime), CAST(N'2021-10-21T00:00:00.000' AS DateTime), NULL, 0, 54, NULL, CAST(N'2021-10-19T10:48:27.210' AS DateTime), N'sf', 1, 12772, 71937, NULL, N'df', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (106, NULL, 4, NULL, NULL, 12316, N'Software', N'trigger test', CAST(N'2021-10-19T00:00:00.000' AS DateTime), CAST(N'2021-10-22T00:00:00.000' AS DateTime), NULL, 0, 55, NULL, CAST(N'2021-10-20T14:13:35.420' AS DateTime), N'test', 1, 12316, 71945, NULL, N'testing', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (107, NULL, 5, NULL, NULL, 12772, N'Software', N'Testrk20102021', CAST(N'2021-10-29T00:00:00.000' AS DateTime), CAST(N'2021-10-20T00:00:00.000' AS DateTime), NULL, 0, 53, 10789, CAST(N'2021-10-20T14:38:35.187' AS DateTime), N'testtt', 1, 12772, 71947, NULL, N'fen', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (108, NULL, 5, NULL, NULL, 12772, N'Software', N'Testrk20102021', CAST(N'2021-10-20T00:00:00.000' AS DateTime), CAST(N'2021-10-01T00:00:00.000' AS DateTime), NULL, 0, 53, 10780, CAST(N'2021-10-20T15:01:55.380' AS DateTime), N'test', 1, 12772, 71950, NULL, N'test be', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (109, NULL, 6, NULL, NULL, 12772, N'Software', N'Testrk20102021', CAST(N'2021-10-20T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), NULL, 0, 53, 10780, CAST(N'2021-10-20T15:04:14.577' AS DateTime), N'tesss', 1, 12772, 71951, NULL, N'dfg', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (110, NULL, 6, NULL, NULL, 12772, N'Software', N'Testrk18102021', CAST(N'2021-10-20T00:00:00.000' AS DateTime), CAST(N'2021-10-15T00:00:00.000' AS DateTime), NULL, 0, 53, NULL, CAST(N'2021-10-20T15:19:26.607' AS DateTime), N'sdf', 1, 12772, 71952, NULL, N'sdf', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (116, NULL, 6, NULL, NULL, 12772, N'Software', N'20102021', CAST(N'2021-10-20T00:00:00.000' AS DateTime), CAST(N'2021-10-20T00:00:00.000' AS DateTime), NULL, 50, 53, 10780, CAST(N'2021-10-20T16:15:45.627' AS DateTime), N'test', NULL, 12772, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (117, NULL, 5, NULL, NULL, 12772, N'Hardware', N'Testrk18102021', CAST(N'2021-10-15T00:00:00.000' AS DateTime), CAST(N'2021-10-16T00:00:00.000' AS DateTime), NULL, 0, 53, 10780, CAST(N'2021-10-21T09:43:34.057' AS DateTime), N'dfd', 1, 12772, 71962, NULL, N'fdg', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (118, NULL, 6, NULL, NULL, 12772, N'Hardware', N'Testrk18102021', CAST(N'2021-10-22T00:00:00.000' AS DateTime), CAST(N'2021-10-30T00:00:00.000' AS DateTime), NULL, 0, 54, 10704, CAST(N'2021-10-21T09:50:16.893' AS DateTime), N'df', 1, 12316, 71963, NULL, N'dsf', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (119, NULL, 2, NULL, NULL, 12940, N'Software', N'mail', CAST(N'2021-10-22T00:00:00.000' AS DateTime), CAST(N'2021-10-23T00:00:00.000' AS DateTime), NULL, 0, 55, NULL, CAST(N'2021-10-21T10:22:09.667' AS DateTime), N'Mail', 1, 12316, 71966, NULL, N'test', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (120, NULL, 4, NULL, NULL, 10707, N'Software', N'Efashion New', CAST(N'2021-10-25T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), NULL, 0, 46, NULL, CAST(N'2021-10-25T09:18:47.200' AS DateTime), N'sales by items', 1, 10780, 71968, NULL, N'webapplication and friendly user', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (128, 2, 5, NULL, NULL, 987654, N'Software', N'Eureka_PMS_TESTING', CAST(N'2023-10-12T10:30:00.000' AS DateTime), CAST(N'2023-11-30T15:45:00.000' AS DateTime), CAST(N'2023-12-15T18:00:00.000' AS DateTime), 75.5, 46, 987654, CAST(N'2023-10-12T08:00:00.000' AS DateTime), N'Description of the project', 123456, 654321, 789012, N'pms@example.com', N'MORE benefits', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (129, NULL, 3, NULL, NULL, NULL, N'Software', N'SDFGSDFDSF', CAST(N'2023-10-14T00:00:00.000' AS DateTime), CAST(N'2023-10-21T00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'DFSDFSDFSD', NULL, NULL, NULL, NULL, N'DSFSDFSDFSD', NULL, NULL, NULL, NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (130, NULL, 2, NULL, NULL, NULL, N'2', N'Eureka PMS', CAST(N'2023-10-23T00:00:00.000' AS DateTime), CAST(N'2023-10-31T00:00:00.000' AS DateTime), CAST(N'2023-11-02T00:00:00.000' AS DateTime), 80, 45, NULL, NULL, N'PMS', NULL, NULL, NULL, N'', NULL, N'978ac6e8-cc12-42a0-0928-08db65aadd90', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55', N'd05635ae-45bd-4842-44db-08dba3c49927', NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (131, NULL, 2, NULL, NULL, NULL, N'2', N'wdsawasds', CAST(N'2023-10-17T00:00:00.000' AS DateTime), CAST(N'2023-11-04T00:00:00.000' AS DateTime), CAST(N'2001-01-01T00:00:00.000' AS DateTime), 75, 46, NULL, NULL, N'asdasdawew', NULL, NULL, NULL, N'testing@gmail.com', NULL, N'978ac6e8-cc12-42a0-0928-08db65aadd90', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55', N'd05635ae-45bd-4842-44db-08dba3c49927', NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (132, NULL, 2, NULL, NULL, NULL, N'Software', N'fgsdfgsdfsd', CAST(N'2023-11-10T00:00:00.000' AS DateTime), CAST(N'2023-11-11T00:00:00.000' AS DateTime), NULL, NULL, 46, NULL, NULL, N'fsdfsdfsd', NULL, NULL, NULL, NULL, N'fsdfsdfsd', N'd05635ae-45bd-4842-44db-08dba3c49927', N'd05635ae-45bd-4842-44db-08dba3c49927', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55', NULL)
INSERT [dbo].[tblProject] ([Pm_Id], [Comp_Code], [CompanyName], [Dept_Code], [Div_Code], [OwnerName], [Category], [ProjectName], [StartDate], [PromiseDate], [FinishDate], [Percentage], [HandeledByTeam], [DevelopedBy], [CreateOn], [Project_Description], [CreatedBy], [FollowUpBy], [CallId], [MailCC], [BenefitForCompany], [RequestedBy], [AssignedTo], [FollowUp], [Status]) VALUES (133, NULL, 1, NULL, NULL, NULL, N'Hardware', N'asdaaS', CAST(N'2023-11-02T00:00:00.000' AS DateTime), CAST(N'2023-11-18T00:00:00.000' AS DateTime), CAST(N'2001-01-01T00:00:00.000' AS DateTime), NULL, 53, NULL, NULL, N'ASasAS', NULL, NULL, NULL, N'', NULL, N'268d192e-372e-433e-5051-08dbcef64187', N'e9f8552b-7f78-4f20-7a8c-08dbcee4db55', N'd05635ae-45bd-4842-44db-08dba3c49927', 1)
SET IDENTITY_INSERT [dbo].[tblProject] OFF
GO
SET IDENTITY_INSERT [dbo].[tblProjectDetail] ON 

INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (8, 52, N'ryty', N'The HTML design -Prototype
Implementation and release will be done on use case basis', CAST(N'2021-10-20T13:35:05.190' AS DateTime), N'Admin', CAST(N'2021-10-05T00:00:00.000' AS DateTime), CAST(N'2021-10-22T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71681, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (9, 52, N'xgd nzdhhfghfg', N'Initial Setup (Creating Structure, Solution Setup)', CAST(N'2021-10-20T14:24:59.303' AS DateTime), N'Admin', CAST(N'2021-10-18T00:00:00.000' AS DateTime), CAST(N'2021-10-21T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71682, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (10, 52, N'hello', N'Sign up via a mobile number or email id', CAST(N'2021-10-13T14:14:08.407' AS DateTime), N'Admin', CAST(N'2021-10-31T00:00:00.000' AS DateTime), CAST(N'2021-10-31T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71683, 0, 0, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (11, 52, N'dfg', N'OTP Verification', CAST(N'2021-10-18T12:36:41.350' AS DateTime), N'Admin', CAST(N'2021-08-11T00:00:00.000' AS DateTime), CAST(N'2021-08-14T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71684, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (12, 52, N'dfgs          hg', N'Use Eureka account if exist', CAST(N'2021-10-20T11:17:49.103' AS DateTime), N'Admin', CAST(N'2021-08-09T00:00:00.000' AS DateTime), CAST(N'2021-08-20T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71685, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (13, 52, N'gdgdfg', N'Account details required to Complete signup- 
Name,
Email id (If singup with mobile no.)', CAST(N'2021-10-18T12:12:49.673' AS DateTime), N'Admin', CAST(N'2021-08-09T00:00:00.000' AS DateTime), CAST(N'2021-08-20T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71686, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (14, 52, NULL, N'Update profile', CAST(N'2021-10-18T12:30:12.860' AS DateTime), N'Admin', CAST(N'2021-08-20T00:00:00.000' AS DateTime), CAST(N'2021-08-25T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71687, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (15, 52, NULL, N'Dynamic CMS page', CAST(N'2021-10-18T12:37:00.623' AS DateTime), N'Admin', CAST(N'2021-08-18T00:00:00.000' AS DateTime), CAST(N'2021-08-25T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71688, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (16, 52, NULL, N'Add details to create Gift link', CAST(N'2021-09-26T11:19:15.367' AS DateTime), N'Admin', CAST(N'2021-08-20T00:00:00.000' AS DateTime), CAST(N'2021-08-25T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71689, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (17, 52, NULL, N'Search Items', CAST(N'2021-10-18T14:15:13.777' AS DateTime), N'Admin', CAST(N'2021-08-25T00:00:00.000' AS DateTime), CAST(N'2021-09-02T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71690, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (18, 52, NULL, N'Browse Items by Category and Sub category', CAST(N'2021-09-26T11:19:52.323' AS DateTime), N'Admin', CAST(N'2021-08-25T00:00:00.000' AS DateTime), CAST(N'2021-09-02T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71691, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (19, 52, NULL, N'Items Listing', CAST(N'2021-10-18T12:38:28.557' AS DateTime), N'Admin', CAST(N'2021-08-25T00:00:00.000' AS DateTime), CAST(N'2021-09-02T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71692, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (20, 52, NULL, N'Items Filters & sorting', CAST(N'2021-09-26T11:20:08.920' AS DateTime), N'Admin', CAST(N'2021-08-25T00:00:00.000' AS DateTime), CAST(N'2021-09-02T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71693, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (21, 52, NULL, N'Item Details , Item Gallery', CAST(N'2021-09-26T11:20:17.287' AS DateTime), N'Admin', CAST(N'2021-08-25T00:00:00.000' AS DateTime), CAST(N'2021-09-02T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71694, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (22, 52, NULL, N' Add item to Wishlist, Remove item from wish list', CAST(N'2021-09-26T11:20:25.017' AS DateTime), N'Admin', CAST(N'2021-08-25T00:00:00.000' AS DateTime), CAST(N'2021-09-02T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71695, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (23, 52, NULL, N'Receive Gift Link- Submit ', CAST(N'2021-09-26T11:20:34.907' AS DateTime), N'Admin', CAST(N'2021-09-02T00:00:00.000' AS DateTime), CAST(N'2021-09-10T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71696, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (24, 52, NULL, N'Receive Gift Link- Pending', CAST(N'2021-09-26T11:20:41.183' AS DateTime), N'Admin', CAST(N'2021-09-02T00:00:00.000' AS DateTime), CAST(N'2021-09-10T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71697, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (25, 52, NULL, N'Receive Gift Link- Approved', CAST(N'2021-09-26T11:20:48.250' AS DateTime), N'Admin', CAST(N'2021-09-02T00:00:00.000' AS DateTime), CAST(N'2021-09-10T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71698, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (26, 52, NULL, N'Receive Gift Link- Close Automaticaly on end date or Manually', CAST(N'2021-09-26T11:20:55.577' AS DateTime), N'Admin', CAST(N'2021-09-02T00:00:00.000' AS DateTime), CAST(N'2021-09-10T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71699, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (27, 52, NULL, N'Gift link list,  Image of the Gift link and name', CAST(N'2021-09-26T11:21:02.400' AS DateTime), N'Admin', CAST(N'2021-09-02T00:00:00.000' AS DateTime), CAST(N'2021-09-10T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71700, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (28, 52, NULL, N'My Gift Links', CAST(N'2021-09-26T11:21:08.803' AS DateTime), N'Admin', CAST(N'2021-09-02T00:00:00.000' AS DateTime), CAST(N'2021-09-10T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71701, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (29, 52, NULL, N'Search Gift link by name, Mobile no. , Gift link ID ', CAST(N'2021-09-26T11:21:16.887' AS DateTime), N'Admin', CAST(N'2021-09-10T00:00:00.000' AS DateTime), CAST(N'2021-09-23T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71702, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (30, 52, NULL, N'Get gift link detail directly by Shared link.', CAST(N'2021-09-26T11:21:24.117' AS DateTime), N'Admin', CAST(N'2021-09-10T00:00:00.000' AS DateTime), CAST(N'2021-09-23T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71703, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (31, 52, NULL, N'Contibution amount', CAST(N'2021-09-26T11:21:30.533' AS DateTime), N'Admin', CAST(N'2021-09-10T00:00:00.000' AS DateTime), CAST(N'2021-09-23T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71704, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (32, 52, NULL, N'Graph progress bar', CAST(N'2021-09-26T11:21:36.680' AS DateTime), N'Admin', CAST(N'2021-09-10T00:00:00.000' AS DateTime), CAST(N'2021-09-23T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71705, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (33, 52, NULL, N'Progress wrt items', CAST(N'2021-09-26T11:21:43.610' AS DateTime), N'Admin', CAST(N'2021-09-10T00:00:00.000' AS DateTime), CAST(N'2021-09-23T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71706, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (34, 52, NULL, N'Add contribution amount to reciever''s wallet', CAST(N'2021-09-26T11:21:51.110' AS DateTime), N'Admin', CAST(N'2021-09-10T00:00:00.000' AS DateTime), CAST(N'2021-09-23T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71707, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (35, 52, NULL, N'Add  / Remove item to Cart - When gift link closes', CAST(N'2021-09-26T11:21:58.433' AS DateTime), N'Admin', CAST(N'2021-09-10T00:00:00.000' AS DateTime), CAST(N'2021-09-23T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71708, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (36, 52, NULL, N'Pricing details', CAST(N'2021-09-26T11:22:04.760' AS DateTime), N'Admin', CAST(N'2021-09-10T00:00:00.000' AS DateTime), CAST(N'2021-09-23T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71709, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (37, 52, NULL, N'Billing / Shipping Address', CAST(N'2021-10-13T14:10:40.537' AS DateTime), N'Admin', CAST(N'2021-10-08T00:00:00.000' AS DateTime), CAST(N'2021-10-13T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71710, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (38, 52, NULL, N'Proceed to payment', CAST(N'2021-10-20T11:57:48.960' AS DateTime), N'Admin', CAST(N'2021-09-23T00:00:00.000' AS DateTime), CAST(N'2021-10-20T11:57:48.960' AS DateTime), N'Completed', NULL, NULL, 71711, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (39, 52, NULL, N'Payment Gateways', CAST(N'2021-10-20T13:07:54.120' AS DateTime), N'Admin', CAST(N'2021-06-10T00:00:00.000' AS DateTime), CAST(N'2021-10-20T13:07:54.120' AS DateTime), N'Completed', NULL, NULL, 71712, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (40, 52, NULL, N'Order Confirmation', CAST(N'2021-10-20T11:58:15.173' AS DateTime), N'Admin', CAST(N'2021-10-06T00:00:00.000' AS DateTime), CAST(N'2021-10-20T11:58:15.173' AS DateTime), N'Completed', NULL, NULL, 71713, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (41, 52, NULL, N'Invoices, Email Invoice', CAST(N'2021-10-20T13:08:55.327' AS DateTime), N'Admin', CAST(N'2021-10-12T00:00:00.000' AS DateTime), CAST(N'2021-10-20T13:08:55.327' AS DateTime), N'Completed', NULL, NULL, 71714, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (42, 52, N'fhvv', N'Show sender list for the gift link', CAST(N'2021-10-18T11:16:21.327' AS DateTime), N'Admin', CAST(N'2021-10-05T00:00:00.000' AS DateTime), CAST(N'2021-10-13T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71715, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (43, 52, N'cvgxc', N'Send detail for the contribution', CAST(N'2021-10-18T11:15:58.573' AS DateTime), N'Admin', CAST(N'2021-09-03T00:00:00.000' AS DateTime), CAST(N'2021-10-13T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71716, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (44, 52, NULL, N'Gift link list', CAST(N'2021-09-26T11:22:18.827' AS DateTime), N'Admin', CAST(N'2021-09-10T00:00:00.000' AS DateTime), CAST(N'2021-09-17T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71717, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (45, 52, NULL, N'Gift link details', CAST(N'2021-10-05T11:33:33.140' AS DateTime), N'Admin', CAST(N'2021-09-10T00:00:00.000' AS DateTime), CAST(N'2021-09-17T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71718, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (46, 52, NULL, N'Contribute for the Gift link, Make payment to send Gift', CAST(N'2021-10-05T11:33:38.990' AS DateTime), N'Admin', CAST(N'2021-09-10T00:00:00.000' AS DateTime), CAST(N'2021-09-17T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71719, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (47, 52, NULL, N'Payment method
-Wallet
- Credit Card
- Knet', CAST(N'2021-10-13T12:55:19.417' AS DateTime), N'Admin', CAST(N'2021-10-13T00:00:00.000' AS DateTime), CAST(N'2021-10-15T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71720, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (48, 52, NULL, N'My Send Gifts list, My Send Gifts details', CAST(N'2021-10-13T12:56:16.597' AS DateTime), N'Admin', CAST(N'2021-10-09T00:00:00.000' AS DateTime), CAST(N'2021-10-13T12:56:16.597' AS DateTime), N'Completed', NULL, NULL, 71721, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (49, 52, NULL, N'Wallet - Balance', CAST(N'2021-10-13T13:15:44.317' AS DateTime), N'Admin', CAST(N'2021-10-12T00:00:00.000' AS DateTime), CAST(N'2021-10-13T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71722, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (50, 52, NULL, N'Add money to Wallet,  Payment gateway', CAST(N'2021-10-13T13:16:06.930' AS DateTime), N'Admin', CAST(N'2021-10-12T00:00:00.000' AS DateTime), CAST(N'2021-10-13T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71723, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (51, 52, NULL, N'Back End (admin)  --- Manage dynamic pages', CAST(N'2021-10-13T13:02:42.507' AS DateTime), N'Admin', CAST(N'2021-10-13T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71724, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (52, 52, NULL, N'Manage Occasion Category, Items', CAST(N'2021-10-13T13:02:57.860' AS DateTime), N'Admin', CAST(N'2021-10-13T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71725, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (53, 52, NULL, N'View Gift links  Notes01102021', CAST(N'2021-10-17T14:14:19.537' AS DateTime), NULL, CAST(N'2021-10-15T00:00:00.000' AS DateTime), CAST(N'2021-10-20T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, NULL, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (54, 52, NULL, N'Approve / Reject  Gift links', CAST(N'2021-10-13T13:03:44.643' AS DateTime), N'Admin', CAST(N'2021-10-15T00:00:00.000' AS DateTime), CAST(N'2021-10-17T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71727, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (55, 52, NULL, N'View All orders', CAST(N'2021-10-13T13:04:08.900' AS DateTime), N'Admin', CAST(N'2021-10-18T00:00:00.000' AS DateTime), CAST(N'2021-10-20T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71728, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (56, 52, NULL, N'Orders status ', CAST(N'2021-10-13T13:04:22.757' AS DateTime), N'Admin', CAST(N'2021-10-18T00:00:00.000' AS DateTime), CAST(N'2021-10-20T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71729, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (57, 52, NULL, N'Orders Delivery', CAST(N'2021-10-20T11:34:26.087' AS DateTime), N'Admin', CAST(N'2021-10-19T00:00:00.000' AS DateTime), CAST(N'2021-10-21T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71730, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (58, 52, NULL, N'Manage invoices', CAST(N'2021-10-20T11:58:26.313' AS DateTime), N'Admin', CAST(N'2021-10-07T00:00:00.000' AS DateTime), CAST(N'2021-10-20T11:58:26.313' AS DateTime), N'Completed', NULL, NULL, 71731, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (59, 52, NULL, N'Testing (QA) and Project Management
 Test Planning
 Test Cases (Optional)
 Bug reporting
 Bug fixing
 Staging deployment (for review and testing)
" Itertative testing and deployment for Agile Development and progress.
 Bug reporting and bug fixing shared transparently with the client."', CAST(N'2021-10-17T11:41:01.780' AS DateTime), N'Admin', CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2021-10-20T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71732, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (60, 52, NULL, N'Release and UAT activities (Transation phase)
 UAT (User Acceptance testing)
Production Deployment (Optional)
"Sign off from the client
Release notes, Help files, documentation handover to the client
Feedback received"
', CAST(N'2021-10-20T11:58:00.027' AS DateTime), N'Admin', CAST(N'2021-10-01T00:00:00.000' AS DateTime), CAST(N'2021-10-20T11:58:00.027' AS DateTime), N'Completed', NULL, NULL, 71733, 0, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (119, 73, NULL, N'Each invoice to print in multiples of 40 csm', CAST(N'2021-10-05T11:22:26.563' AS DateTime), N'Admin', CAST(N'2021-06-10T00:00:00.000' AS DateTime), CAST(N'2021-10-31T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71813, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (120, 74, NULL, N'Linking the delivery note with the receipt of goods', CAST(N'2021-10-05T11:42:27.757' AS DateTime), N'Admin', CAST(N'2021-05-25T00:00:00.000' AS DateTime), CAST(N'2021-08-16T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71815, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (165, 78, NULL, N'Upgrade New Bandwidth in Salmiya', CAST(N'2021-10-20T14:31:27.987' AS DateTime), N'Admin', CAST(N'2021-06-21T00:00:00.000' AS DateTime), CAST(N'2021-06-25T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71830, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (167, 78, NULL, N'Upgrade New Bandwidth in Fahaheel', CAST(N'2021-10-05T16:22:22.723' AS DateTime), N'Admin', CAST(N'2021-06-07T00:00:00.000' AS DateTime), CAST(N'2021-06-07T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71832, NULL, NULL, NULL, NULL, 10709)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (182, 76, NULL, N'Increasing the size of mid banner and small banner in all the three palces - wesbite, android app and iOS app', CAST(N'2021-10-05T16:09:06.523' AS DateTime), N'Admin', CAST(N'2021-04-27T00:00:00.000' AS DateTime), CAST(N'2021-09-27T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71837, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (183, 75, NULL, N'Upload of form feed file automatically on FTP server on an hourly basis', CAST(N'2021-10-05T16:10:52.000' AS DateTime), N'Admin', CAST(N'2021-09-26T00:00:00.000' AS DateTime), CAST(N'2021-10-05T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71838, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (184, 77, NULL, N'Adding Amercan express as payment method in the order screen in Admin', CAST(N'2021-10-05T16:12:15.570' AS DateTime), N'Admin', CAST(N'2021-09-29T00:00:00.000' AS DateTime), CAST(N'2021-10-10T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71839, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (185, 82, NULL, N'-Profit Discount ,the invoice will show all the installments covered', CAST(N'2021-10-06T11:08:33.367' AS DateTime), N'Mona Khader', CAST(N'2021-09-20T00:00:00.000' AS DateTime), CAST(N'2021-09-22T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71841, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (194, 82, NULL, N'Change expenses Percentage calculations (in Follow up Screen) should be from Total Contract Balance', CAST(N'2021-10-07T18:04:30.797' AS DateTime), N'Admin', CAST(N'2021-09-21T00:00:00.000' AS DateTime), CAST(N'2021-09-23T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71850, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (195, 83, NULL, N'Removing columns from Customer and Contract screens
and fit all customer info in one page for printing', CAST(N'2021-10-06T11:46:32.167' AS DateTime), N'Mona Khader', CAST(N'2021-03-09T00:00:00.000' AS DateTime), CAST(N'2021-03-10T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71852, NULL, NULL, NULL, NULL, 10789)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (196, 83, NULL, N'All screens (Customers , Contracts ) can be used in both Arabic and english', CAST(N'2021-10-06T11:41:13.077' AS DateTime), N'Mona Khader', CAST(N'2021-03-16T00:00:00.000' AS DateTime), CAST(N'2021-03-22T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71853, NULL, NULL, NULL, NULL, 10789)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (197, 83, NULL, N'Adding  Total Contracts summary at the bottom of the Customer screen', CAST(N'2021-10-06T11:42:48.097' AS DateTime), N'Mona Khader', CAST(N'2021-03-23T00:00:00.000' AS DateTime), CAST(N'2021-03-25T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71854, NULL, NULL, NULL, NULL, 10789)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (198, 83, NULL, N'The font size had been modified to increase the visibility of all screens', CAST(N'2021-10-06T11:45:13.997' AS DateTime), N'Mona Khader', CAST(N'2021-04-05T00:00:00.000' AS DateTime), CAST(N'2021-04-08T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71855, NULL, NULL, NULL, NULL, 10789)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (199, 83, NULL, N'Adding  “Upload Documents” in the main screen of Manage Contract
&  
Making the page scrolling without lower border  In Manage Contract Screen', CAST(N'2021-10-06T11:49:20.177' AS DateTime), N'Mona Khader', CAST(N'2021-04-11T00:00:00.000' AS DateTime), CAST(N'2021-04-12T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71856, NULL, NULL, NULL, NULL, 10789)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (200, 83, NULL, N'all four reports in contract Screen had been modified and uploaded as their needs', CAST(N'2021-10-06T11:51:09.803' AS DateTime), N'Mona Khader', CAST(N'2021-04-13T00:00:00.000' AS DateTime), CAST(N'2021-04-15T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71857, NULL, NULL, NULL, NULL, 10789)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (201, 83, NULL, N'Allowing Manual profit entering for one schem in Contract Screen ( Home Aplliances)', CAST(N'2021-10-06T11:53:36.047' AS DateTime), N'Mona Khader', CAST(N'2021-09-20T00:00:00.000' AS DateTime), CAST(N'2021-09-21T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71858, NULL, NULL, NULL, NULL, 10789)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (202, 83, NULL, N'testing and Contact with Ahmad Wahid regarding Cinet Report

(He is travelling)', CAST(N'2021-10-20T13:15:55.220' AS DateTime), N'Mona Khader', CAST(N'2021-10-03T00:00:00.000' AS DateTime), CAST(N'2021-10-20T13:15:55.220' AS DateTime), N'Completed', NULL, NULL, 71859, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (203, 84, NULL, N'Start Building the Screens 
Payment, Follow up, Monthly Transcation', CAST(N'2021-10-06T12:14:57.650' AS DateTime), N'Mona Khader', CAST(N'2021-08-04T00:00:00.000' AS DateTime), CAST(N'2021-08-18T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71861, NULL, NULL, NULL, NULL, 10789)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (204, 84, NULL, N'Adding Screens( Customers Classifications, Ecredit Employees)', CAST(N'2021-10-06T12:17:31.957' AS DateTime), N'Mona Khader', CAST(N'2021-09-01T00:00:00.000' AS DateTime), CAST(N'2021-09-06T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71862, NULL, NULL, NULL, NULL, 10789)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (205, 84, NULL, N'Building Transaction Distribution screen with all the calcualtions and new distibution tichnique', CAST(N'2021-10-06T12:19:29.917' AS DateTime), N'Mona Khader', CAST(N'2021-09-07T00:00:00.000' AS DateTime), CAST(N'2021-09-16T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71863, NULL, NULL, NULL, NULL, 10789)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (206, 84, NULL, N'Legal Screens (not started yet)', CAST(N'2021-10-20T13:10:50.087' AS DateTime), N'Mona Khader', CAST(N'2021-10-13T00:00:00.000' AS DateTime), CAST(N'2021-10-20T13:10:50.087' AS DateTime), N'Completed', NULL, NULL, 71864, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (208, 85, NULL, N'CRM Demo from Sheetal 
and admin Credentials for CRM System and emall App in mobile', CAST(N'2021-10-06T15:26:33.847' AS DateTime), N'Admin', CAST(N'2021-04-15T00:00:00.000' AS DateTime), CAST(N'2021-04-15T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71867, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (209, 85, NULL, N'Vendor Application sent by Sandeep and installed  on Android gun', CAST(N'2021-10-06T15:31:57.333' AS DateTime), N'Admin', CAST(N'2021-05-12T00:00:00.000' AS DateTime), CAST(N'2021-05-12T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71868, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (210, 85, NULL, N'excel Sheet for retention and contribution calculations sent by Mr. Khaled', CAST(N'2021-10-06T15:33:06.917' AS DateTime), N'Admin', CAST(N'2021-06-01T00:00:00.000' AS DateTime), CAST(N'2021-06-01T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71869, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (211, 85, NULL, N'Removing (trancate) all CRM data by Sandeep and start full testing', CAST(N'2021-10-06T15:40:22.497' AS DateTime), N'Admin', CAST(N'2021-06-22T00:00:00.000' AS DateTime), CAST(N'2021-06-22T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71870, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (212, 85, NULL, N'Meeting with Mohammad alqenai and explianing for him and showing the full cycle and the results for all the apllications in CRM', CAST(N'2021-10-06T16:00:58.517' AS DateTime), N'Admin', CAST(N'2021-06-23T00:00:00.000' AS DateTime), CAST(N'2021-06-23T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71871, NULL, NULL, NULL, NULL, 10789)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (213, 85, NULL, N'Problem in Vedor App reported by Mohamed and Solved', CAST(N'2021-10-06T16:05:03.367' AS DateTime), N'Mona Khader', CAST(N'2021-09-01T00:00:00.000' AS DateTime), CAST(N'2021-09-02T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71872, NULL, NULL, NULL, NULL, 10789)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (214, 85, NULL, N'Coupon Calculations (retention value) correction', CAST(N'2021-10-06T16:07:38.243' AS DateTime), N'Mona Khader', CAST(N'2021-10-02T00:00:00.000' AS DateTime), CAST(N'2021-10-02T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71873, NULL, NULL, NULL, NULL, 10789)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (215, 86, NULL, N'Required Document sent to auditors', CAST(N'2021-10-12T12:44:57.893' AS DateTime), N'RAFEE HAMED SHAIK MOIDINE', CAST(N'2021-06-30T00:00:00.000' AS DateTime), CAST(N'2021-06-30T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71875, NULL, NULL, NULL, NULL, 10704)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (216, 85, NULL, N'Points Contribution Correction reported by Mr. Mohamad alqenai', CAST(N'2021-10-12T13:46:31.260' AS DateTime), N'Admin', CAST(N'2021-10-12T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71877, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (217, 83, NULL, N'Updating Customer details in Arabic not working', CAST(N'2021-10-20T13:16:04.640' AS DateTime), N'Admin', CAST(N'2021-10-06T00:00:00.000' AS DateTime), CAST(N'2021-10-20T13:16:04.640' AS DateTime), N'Completed', NULL, NULL, 71878, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (218, 87, NULL, N'Site visited on 10th October and discussed with Mr. Bilal collected the job description 
1.	Service center move to ground floor
2.	Computer section HOS counter move to other location
3.	WG HOS Counter move old service center location
4.	Arrangement of temporary service center to cashier section', CAST(N'2021-10-12T15:50:35.687' AS DateTime), N'RAFEE HAMED SHAIK MOIDINE', CAST(N'2021-10-10T00:00:00.000' AS DateTime), CAST(N'2021-10-10T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71879, NULL, NULL, NULL, NULL, 10704)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (219, 87, NULL, N'Job completed flowing job today
1.	Arrangement of temporary service center to cashier section ( Completed)
2.	Removed all Asset from old service center ( Completed)
3.	Removed all network point old service center ( Completed)
4.	Moved computer section camera to AC Section (old Service center location)  ( Completed)', CAST(N'2021-10-12T15:59:46.970' AS DateTime), N'RAFEE HAMED SHAIK MOIDINE', CAST(N'2021-10-11T00:00:00.000' AS DateTime), CAST(N'2021-10-11T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71880, NULL, NULL, NULL, NULL, 10704)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (220, 88, NULL, N'Mr. Walid requested project cost estimate', CAST(N'2021-10-12T16:27:46.127' AS DateTime), N'RAFEE HAMED SHAIK MOIDINE', CAST(N'2021-04-25T00:00:00.000' AS DateTime), CAST(N'2021-04-25T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71882, NULL, NULL, NULL, NULL, 10704)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (221, 88, NULL, N'Detailed cost estimate send on 29th April 2021', CAST(N'2021-10-12T16:40:52.167' AS DateTime), N'RAFEE HAMED SHAIK MOIDINE', CAST(N'2021-04-25T00:00:00.000' AS DateTime), CAST(N'2021-10-29T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71883, NULL, NULL, NULL, NULL, 10704)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (222, 88, NULL, N'Approved Mr. Walid on 29/04/2021', CAST(N'2021-10-12T16:31:44.473' AS DateTime), N'RAFEE HAMED SHAIK MOIDINE', CAST(N'2021-04-25T00:00:00.000' AS DateTime), CAST(N'2021-04-29T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71884, NULL, NULL, NULL, NULL, 10704)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (223, 88, NULL, N'Send LPO to supplier', CAST(N'2021-10-12T16:39:10.303' AS DateTime), N'RAFEE HAMED SHAIK MOIDINE', CAST(N'2021-04-25T00:00:00.000' AS DateTime), CAST(N'2021-05-05T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71885, NULL, NULL, NULL, NULL, 10704)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (224, 88, NULL, N'Without Voice camera 17 Qty camera received on 17th May', CAST(N'2021-10-12T17:00:56.037' AS DateTime), N'RAFEE HAMED SHAIK MOIDINE', CAST(N'2021-04-25T00:00:00.000' AS DateTime), CAST(N'2021-05-17T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71886, NULL, NULL, NULL, NULL, 10704)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (225, 88, NULL, N'1. Cabling work started for 17 camera completed on 4th jully.
2. Because of the delay cabling path already full so created new path arranged with Mr. Nassif Team', CAST(N'2021-10-12T16:50:39.133' AS DateTime), N'RAFEE HAMED SHAIK MOIDINE', CAST(N'2021-06-09T00:00:00.000' AS DateTime), CAST(N'2021-07-04T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71887, NULL, NULL, NULL, NULL, 10704)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (226, 88, NULL, N'6 voice camera still delay from supplier because new model', CAST(N'2021-10-12T16:59:44.973' AS DateTime), N'RAFEE HAMED SHAIK MOIDINE', CAST(N'2021-04-25T00:00:00.000' AS DateTime), CAST(N'2021-07-04T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71888, NULL, NULL, NULL, NULL, 10704)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (227, 88, NULL, N'Received Voice camera 6 Qty from supplier on 2nd September 2021', CAST(N'2021-10-12T16:59:56.683' AS DateTime), N'RAFEE HAMED SHAIK MOIDINE', CAST(N'2021-04-25T00:00:00.000' AS DateTime), CAST(N'2021-09-02T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71889, NULL, NULL, NULL, NULL, 10704)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (228, 88, NULL, N'All Job Completed on 16th September 2021', CAST(N'2021-10-12T17:03:01.523' AS DateTime), N'RAFEE HAMED SHAIK MOIDINE', CAST(N'2021-06-09T00:00:00.000' AS DateTime), CAST(N'2021-09-16T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71890, NULL, NULL, NULL, NULL, 10704)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (229, 89, NULL, N'Job completed on 06 October 2021 
Changed new camera and fixed MIC', CAST(N'2021-10-12T17:31:30.923' AS DateTime), N'RAFEE HAMED SHAIK MOIDINE', CAST(N'2021-09-29T00:00:00.000' AS DateTime), CAST(N'2021-10-06T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71892, NULL, NULL, NULL, NULL, 10704)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (230, 52, NULL, N'Test 13102021', CAST(N'2021-10-13T14:00:20.527' AS DateTime), N'Admin', CAST(N'2021-10-13T00:00:00.000' AS DateTime), CAST(N'2021-10-29T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71893, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (231, 90, NULL, N'task rtest desc 13102021', CAST(N'2021-10-14T14:27:46.867' AS DateTime), N'Admin', CAST(N'2021-10-15T00:00:00.000' AS DateTime), CAST(N'2021-10-14T14:27:46.867' AS DateTime), N'Completed', NULL, NULL, 71895, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (232, 52, NULL, N'assssdddd', CAST(N'2021-10-20T11:18:10.333' AS DateTime), N'Admin', CAST(N'2021-09-01T00:00:00.000' AS DateTime), CAST(N'2021-10-20T11:18:10.333' AS DateTime), N'Completed', NULL, NULL, 71896, NULL, NULL, NULL, NULL, 1)
GO
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (233, 83, NULL, N'abc  sd', CAST(N'2021-10-20T13:16:14.157' AS DateTime), N'Admin', CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2021-10-20T13:16:14.157' AS DateTime), N'Completed', NULL, NULL, 71898, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (235, 91, NULL, N'hfh', CAST(N'2021-10-14T14:22:58.757' AS DateTime), N'Admin', CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2021-10-14T14:22:47.133' AS DateTime), N'Completed', NULL, NULL, 71900, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (236, 92, NULL, N'test', CAST(N'2021-10-14T14:26:59.187' AS DateTime), N'Admin', CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71902, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (237, 92, NULL, N'gdg', CAST(N'2021-10-14T14:33:02.620' AS DateTime), N'Admin', CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71903, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (238, 91, NULL, N'df', CAST(N'2021-10-14T14:35:53.013' AS DateTime), N'Admin', CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2021-10-14T14:35:53.013' AS DateTime), N'Completed', NULL, NULL, 71904, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (239, 91, NULL, N'dg', CAST(N'2021-10-14T14:36:28.497' AS DateTime), N'Admin', CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71905, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (240, 90, NULL, N'fhgfh', CAST(N'2021-10-14T14:39:09.220' AS DateTime), N'Admin', CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71906, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (241, 90, NULL, N'fff', CAST(N'2021-10-14T14:40:05.833' AS DateTime), N'Admin', CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71907, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (242, 92, NULL, N'gdfg', CAST(N'2021-10-14T14:43:16.913' AS DateTime), N'Admin', CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71908, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (244, 94, NULL, N'fsdfg', CAST(N'2021-10-14T18:32:29.263' AS DateTime), N'Admin', CAST(N'2021-10-15T00:00:00.000' AS DateTime), CAST(N'2021-10-14T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71912, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (245, 96, NULL, N'ddddd', CAST(N'2021-10-17T13:03:04.660' AS DateTime), N'Admin', CAST(N'2021-10-17T00:00:00.000' AS DateTime), CAST(N'2021-10-17T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71915, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (246, 99, N'dfd', N'Tast 18012021', CAST(N'2021-10-20T13:37:23.640' AS DateTime), N'Admin', CAST(N'2021-10-05T00:00:00.000' AS DateTime), CAST(N'2021-10-21T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71919, NULL, NULL, N'e458474b-1c5b-4f35-acfe-ccc4ffb2e82c.jpg', NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (247, 99, N'com111111', N'desc  1111', CAST(N'2021-10-18T12:40:42.703' AS DateTime), N'Admin', CAST(N'2021-10-18T00:00:00.000' AS DateTime), CAST(N'2021-10-18T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71920, NULL, NULL, N'51ed4341-8dc6-453b-bdfc-8d7d93e51be9.jpg', NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (248, 99, N'com', N'desc', CAST(N'2021-10-18T14:19:05.887' AS DateTime), N'Admin', CAST(N'2021-10-18T00:00:00.000' AS DateTime), CAST(N'2021-10-18T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71921, NULL, NULL, N'd97a7b0e-8e60-4ce0-a726-831c079a427e.xlsx', NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (249, 99, N'test comment', N'test', CAST(N'2021-10-20T13:37:43.403' AS DateTime), N'Admin', CAST(N'2021-10-05T00:00:00.000' AS DateTime), CAST(N'2021-10-20T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71922, NULL, NULL, N'137d075c-d9ad-4852-b6f7-398299ba3bfd.jpg', NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (250, 99, N'123', N'123', CAST(N'2021-10-18T13:18:58.187' AS DateTime), N'Admin', CAST(N'2021-10-11T00:00:00.000' AS DateTime), CAST(N'2021-10-20T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71923, NULL, NULL, N'3bb1f520-3926-4cd0-81bb-12e8b5b23946.jpg', NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (251, 83, N'rrr', N'Test', CAST(N'2021-10-20T13:16:26.547' AS DateTime), N'Admin', CAST(N'2021-10-18T00:00:00.000' AS DateTime), CAST(N'2021-10-20T13:16:26.547' AS DateTime), N'Completed', NULL, NULL, 71924, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (252, 83, N'dfg', N'bfd', CAST(N'2021-10-20T13:16:36.487' AS DateTime), N'Admin', CAST(N'2021-10-18T00:00:00.000' AS DateTime), CAST(N'2021-10-20T13:16:36.487' AS DateTime), N'Completed', NULL, NULL, 71925, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (253, 99, N'y', N'y', CAST(N'2021-10-18T13:15:03.120' AS DateTime), N'Admin', CAST(N'2021-10-18T00:00:00.000' AS DateTime), CAST(N'2021-10-18T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71926, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (254, 99, NULL, N'yrty', CAST(N'2021-10-18T13:16:24.543' AS DateTime), N'Admin', CAST(N'2021-10-18T00:00:00.000' AS DateTime), CAST(N'2021-10-18T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71927, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (255, 101, N'tet', N'teswte', CAST(N'2021-10-18T13:48:16.567' AS DateTime), N'Admin', CAST(N'2021-10-14T00:00:00.000' AS DateTime), CAST(N'2021-10-19T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71930, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (256, 82, NULL, N'tet', CAST(N'2021-10-20T13:11:28.257' AS DateTime), N'Admin', CAST(N'2021-10-18T00:00:00.000' AS DateTime), CAST(N'2021-10-20T13:11:28.257' AS DateTime), N'Completed', NULL, NULL, 71931, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (257, 104, NULL, N'Update Payroll', CAST(N'2021-10-18T14:40:57.700' AS DateTime), N'Admin', CAST(N'2021-10-05T00:00:00.000' AS DateTime), CAST(N'2021-10-18T14:40:57.700' AS DateTime), N'Completed', NULL, NULL, 71935, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (258, 87, NULL, N'test', CAST(N'2021-10-19T10:31:22.907' AS DateTime), N'Admin', CAST(N'2021-10-19T00:00:00.000' AS DateTime), CAST(N'2021-10-19T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71936, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (259, 87, NULL, N'rt', CAST(N'2021-10-19T10:48:35.890' AS DateTime), N'Admin', CAST(N'2021-10-19T00:00:00.000' AS DateTime), CAST(N'2021-10-19T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71938, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (260, 87, NULL, N'rt', CAST(N'2021-10-19T10:48:41.967' AS DateTime), N'Admin', CAST(N'2021-10-19T00:00:00.000' AS DateTime), CAST(N'2021-10-19T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71939, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (262, 101, N'insert', N'test insert', CAST(N'2021-10-20T13:50:19.313' AS DateTime), N'Admin', CAST(N'2021-10-18T00:00:00.000' AS DateTime), CAST(N'2021-10-22T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71941, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (263, 52, NULL, N'test', CAST(N'2021-10-20T13:35:48.157' AS DateTime), N'Admin', CAST(N'2021-10-20T00:00:00.000' AS DateTime), CAST(N'2021-10-20T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71942, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (264, 99, NULL, N'test', CAST(N'2021-10-20T13:38:35.233' AS DateTime), N'Admin', CAST(N'2021-10-21T00:00:00.000' AS DateTime), CAST(N'2021-10-30T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71943, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (265, 101, N'123', N'123', CAST(N'2021-10-20T13:49:37.173' AS DateTime), N'Admin', CAST(N'2021-10-03T00:00:00.000' AS DateTime), CAST(N'2021-10-29T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71944, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (266, 106, N'ttt', N'tet', CAST(N'2021-10-20T14:15:36.830' AS DateTime), N'Admin', CAST(N'2021-10-11T00:00:00.000' AS DateTime), CAST(N'2021-10-22T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71946, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (267, 107, N'res', N'test', CAST(N'2021-10-21T08:15:10.733' AS DateTime), N'Admin', CAST(N'2021-10-29T00:00:00.000' AS DateTime), CAST(N'2021-10-31T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71948, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (268, 107, NULL, N'test', CAST(N'2021-10-21T09:42:27.620' AS DateTime), N'Admin', CAST(N'2021-10-29T00:00:00.000' AS DateTime), CAST(N'2021-10-30T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71949, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (269, 116, NULL, N'dg', CAST(N'2021-10-20T16:45:57.057' AS DateTime), N'Admin', CAST(N'2021-10-21T00:00:00.000' AS DateTime), CAST(N'2021-10-22T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71959, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (270, 116, NULL, N'dfgd', CAST(N'2021-10-20T16:46:52.813' AS DateTime), N'Admin', CAST(N'2021-10-20T00:00:00.000' AS DateTime), CAST(N'2021-10-20T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, 71960, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (271, 116, NULL, N'dfg', CAST(N'2021-10-20T16:46:40.247' AS DateTime), N'Admin', CAST(N'2021-10-21T00:00:00.000' AS DateTime), CAST(N'2021-10-29T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71961, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (272, 118, NULL, N'gdfg', CAST(N'2021-10-21T09:55:54.077' AS DateTime), N'Admin', CAST(N'2021-10-22T00:00:00.000' AS DateTime), CAST(N'2021-10-23T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71964, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (273, 103, N'tet', N'test', CAST(N'2021-10-21T10:13:03.297' AS DateTime), N'Admin', CAST(N'2021-10-20T00:00:00.000' AS DateTime), CAST(N'2021-10-22T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71965, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (274, 95, NULL, N'dgh', CAST(N'2021-10-21T10:24:25.677' AS DateTime), N'Admin', CAST(N'2021-10-22T00:00:00.000' AS DateTime), CAST(N'2021-10-29T00:00:00.000' AS DateTime), N'Not Started', NULL, NULL, 71967, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (275, 120, NULL, N'display the all item sales', CAST(N'2021-10-25T09:22:17.430' AS DateTime), N'Admin', CAST(N'2021-10-25T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, 71969, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (276, NULL, N'aaaaaaaaaa', N'aaaaaa', NULL, NULL, CAST(N'2023-10-20T00:00:00.000' AS DateTime), CAST(N'2023-10-21T00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, 0, NULL, N'', CAST(N'2023-10-20T10:12:53.990' AS DateTime), NULL)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (277, NULL, N'aaaaaaa', N'aaaa', NULL, NULL, CAST(N'2023-10-08T00:00:00.000' AS DateTime), CAST(N'2023-10-09T00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, 0, NULL, N'', CAST(N'2023-10-20T10:17:26.773' AS DateTime), NULL)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (278, NULL, N'aaaaaaa', N'aaaaa', NULL, NULL, CAST(N'2023-10-04T00:00:00.000' AS DateTime), CAST(N'2023-10-06T00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, 0, NULL, N'', CAST(N'2023-10-20T10:18:46.730' AS DateTime), NULL)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (279, 52, N'eeeee', N'eeeeeeee', NULL, NULL, CAST(N'2023-10-06T00:00:00.000' AS DateTime), CAST(N'2023-10-13T00:00:00.000' AS DateTime), N'NotStarted', NULL, NULL, NULL, 0, 0, N'', CAST(N'2023-10-20T10:21:01.753' AS DateTime), 0)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (280, 52, N'dsasdas', N'sadesads', NULL, NULL, CAST(N'2023-10-12T00:00:00.000' AS DateTime), CAST(N'2023-10-25T00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, 0, NULL, N'', CAST(N'2023-10-20T19:18:43.153' AS DateTime), NULL)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (281, 52, N'dhflosd', N'Razi', NULL, NULL, CAST(N'2023-10-07T00:00:00.000' AS DateTime), CAST(N'2023-10-06T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, NULL, 0, 0, N'', CAST(N'2023-10-23T16:10:08.817' AS DateTime), 0)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (282, 52, N'sdfasfasd', N'asdasdf', NULL, NULL, CAST(N'2023-10-01T00:00:00.000' AS DateTime), CAST(N'2023-10-27T00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, 0, NULL, N'', CAST(N'2023-10-25T19:28:53.207' AS DateTime), NULL)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (283, 131, N'No Comment at all', N'Alpha beta Gamma', NULL, NULL, CAST(N'2023-10-11T00:00:00.000' AS DateTime), CAST(N'2023-10-28T00:00:00.000' AS DateTime), N'Completed', NULL, NULL, NULL, 0, 0, N'', CAST(N'2023-10-30T15:35:56.710' AS DateTime), 0)
INSERT [dbo].[tblProjectDetail] ([Id], [Project_FK_Id], [Comment], [Description], [cDatetime], [ActionBy], [StartDate], [EndDate], [Status], [AssignTo], [CallGroup], [CallId], [ReOpen], [ReopenBy], [File], [CreatedOn], [CreatedBy]) VALUES (284, 52, N'sdfsdfsdfsd', N'sdfsdfsd', NULL, N'', CAST(N'2023-11-02T00:00:00.000' AS DateTime), CAST(N'2023-12-03T00:00:00.000' AS DateTime), N'In Progress', NULL, NULL, NULL, 0, NULL, N'C:\fakepath\25Sep.txt', CAST(N'2023-10-31T16:43:08.390' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[tblProjectDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[TeamManage] ON 

INSERT [dbo].[TeamManage] ([Id], [Category], [Team], [Developer], [CreatedOn], [CreatedBy], [Status]) VALUES (45, N'Software', N'Eureka1', N'533', CAST(N'2015-09-17T15:43:03.813' AS DateTime), NULL, 0)
INSERT [dbo].[TeamManage] ([Id], [Category], [Team], [Developer], [CreatedOn], [CreatedBy], [Status]) VALUES (46, N'Software', N'Intigate ODC', N'90', CAST(N'2015-09-17T14:48:02.200' AS DateTime), NULL, 1)
INSERT [dbo].[TeamManage] ([Id], [Category], [Team], [Developer], [CreatedOn], [CreatedBy], [Status]) VALUES (47, N'Software', N'ESC', N'625,462', CAST(N'2015-09-17T15:30:02.087' AS DateTime), NULL, 0)
INSERT [dbo].[TeamManage] ([Id], [Category], [Team], [Developer], [CreatedOn], [CreatedBy], [Status]) VALUES (48, N'Software', N'Tour1', N'412', CAST(N'2015-09-17T15:45:58.330' AS DateTime), NULL, 0)
INSERT [dbo].[TeamManage] ([Id], [Category], [Team], [Developer], [CreatedOn], [CreatedBy], [Status]) VALUES (49, N'Software', N'TT', N'116,462,412', CAST(N'2015-09-17T16:00:37.987' AS DateTime), NULL, 0)
INSERT [dbo].[TeamManage] ([Id], [Category], [Team], [Developer], [CreatedOn], [CreatedBy], [Status]) VALUES (50, N'Software', N'Inte', N'625,90,561', CAST(N'2015-09-17T16:19:04.260' AS DateTime), NULL, 0)
INSERT [dbo].[TeamManage] ([Id], [Category], [Team], [Developer], [CreatedOn], [CreatedBy], [Status]) VALUES (51, NULL, N'Culture2', NULL, CAST(N'2015-09-20T12:41:31.893' AS DateTime), NULL, 0)
INSERT [dbo].[TeamManage] ([Id], [Category], [Team], [Developer], [CreatedOn], [CreatedBy], [Status]) VALUES (52, NULL, N'culture15', NULL, CAST(N'2015-09-20T13:06:46.207' AS DateTime), NULL, 0)
INSERT [dbo].[TeamManage] ([Id], [Category], [Team], [Developer], [CreatedOn], [CreatedBy], [Status]) VALUES (53, N'Software', N'Software Team', NULL, CAST(N'2020-07-02T09:40:35.550' AS DateTime), NULL, 1)
INSERT [dbo].[TeamManage] ([Id], [Category], [Team], [Developer], [CreatedOn], [CreatedBy], [Status]) VALUES (54, N'Hardware', N'Hardware', NULL, CAST(N'2021-10-01T09:22:35.920' AS DateTime), NULL, 1)
INSERT [dbo].[TeamManage] ([Id], [Category], [Team], [Developer], [CreatedOn], [CreatedBy], [Status]) VALUES (55, N'Software', N'Intigate', NULL, CAST(N'2021-10-01T09:22:51.427' AS DateTime), NULL, 1)
SET IDENTITY_INSERT [dbo].[TeamManage] OFF
GO
SET IDENTITY_INSERT [UserManagement].[NavigationMenus] ON 

INSERT [UserManagement].[NavigationMenus] ([Id], [ParentID], [MenuName], [MenuUrl], [MenuIcon], [IsActive], [SortOrder], [Type]) VALUES (1, NULL, N'Dashboard', N'dashboard', NULL, 1, N'1', 0)
INSERT [UserManagement].[NavigationMenus] ([Id], [ParentID], [MenuName], [MenuUrl], [MenuIcon], [IsActive], [SortOrder], [Type]) VALUES (2, NULL, N'Admin', NULL, NULL, 1, N'2', 0)
INSERT [UserManagement].[NavigationMenus] ([Id], [ParentID], [MenuName], [MenuUrl], [MenuIcon], [IsActive], [SortOrder], [Type]) VALUES (3, 2, N'User List', N'admin/userlist', NULL, 1, N'1', 0)
INSERT [UserManagement].[NavigationMenus] ([Id], [ParentID], [MenuName], [MenuUrl], [MenuIcon], [IsActive], [SortOrder], [Type]) VALUES (4, NULL, N'IT', NULL, NULL, 1, N'3', 0)
INSERT [UserManagement].[NavigationMenus] ([Id], [ParentID], [MenuName], [MenuUrl], [MenuIcon], [IsActive], [SortOrder], [Type]) VALUES (5, 4, N'Login User', N'it/loginuser', NULL, 1, N'1', 0)
INSERT [UserManagement].[NavigationMenus] ([Id], [ParentID], [MenuName], [MenuUrl], [MenuIcon], [IsActive], [SortOrder], [Type]) VALUES (6, NULL, N'Projects', NULL, NULL, 1, N'4', 0)
INSERT [UserManagement].[NavigationMenus] ([Id], [ParentID], [MenuName], [MenuUrl], [MenuIcon], [IsActive], [SortOrder], [Type]) VALUES (7, 6, N'Project Management', N'projects/projectmanagement', NULL, 1, N'1', 0)
INSERT [UserManagement].[NavigationMenus] ([Id], [ParentID], [MenuName], [MenuUrl], [MenuIcon], [IsActive], [SortOrder], [Type]) VALUES (8, NULL, N'Master', NULL, NULL, 1, N'5', 0)
INSERT [UserManagement].[NavigationMenus] ([Id], [ParentID], [MenuName], [MenuUrl], [MenuIcon], [IsActive], [SortOrder], [Type]) VALUES (9, 8, N'Master Table', N'master/mastertable', NULL, 1, N'1', 0)
SET IDENTITY_INSERT [UserManagement].[NavigationMenus] OFF
GO
SET IDENTITY_INSERT [UserManagement].[PrivilegeActions] ON 

INSERT [UserManagement].[PrivilegeActions] ([Id], [Privilege], [IsActive]) VALUES (1, N'Add', 1)
INSERT [UserManagement].[PrivilegeActions] ([Id], [Privilege], [IsActive]) VALUES (2, N'Edit', 1)
INSERT [UserManagement].[PrivilegeActions] ([Id], [Privilege], [IsActive]) VALUES (3, N'Delete', 1)
INSERT [UserManagement].[PrivilegeActions] ([Id], [Privilege], [IsActive]) VALUES (4, N'View', 1)
INSERT [UserManagement].[PrivilegeActions] ([Id], [Privilege], [IsActive]) VALUES (5, N'Print/Export', 1)
INSERT [UserManagement].[PrivilegeActions] ([Id], [Privilege], [IsActive]) VALUES (6, N'All', 1)
INSERT [UserManagement].[PrivilegeActions] ([Id], [Privilege], [IsActive]) VALUES (7, N'Ali', 0)
SET IDENTITY_INSERT [UserManagement].[PrivilegeActions] OFF
GO
SET IDENTITY_INSERT [UserManagement].[RolesPrivileges] ON 

INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (392, N'c501dcef-002a-4a4b-475e-08dba2e5642c', 3, 1, 1, NULL, CAST(N'2023-08-22T08:00:35.477' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (393, N'c501dcef-002a-4a4b-475e-08dba2e5642c', 11, 2, 1, NULL, CAST(N'2023-08-22T08:00:35.477' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (394, N'c501dcef-002a-4a4b-475e-08dba2e5642c', 14, 4, 1, NULL, CAST(N'2023-08-22T08:00:35.477' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (395, N'c501dcef-002a-4a4b-475e-08dba2e5642c', 2, 1, 1, NULL, CAST(N'2023-08-22T08:00:35.477' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (396, N'c501dcef-002a-4a4b-475e-08dba2e5642c', 2, 5, 1, NULL, CAST(N'2023-08-22T08:00:35.477' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (397, N'c501dcef-002a-4a4b-475e-08dba2e5642c', 4, 5, 1, NULL, CAST(N'2023-08-22T08:00:35.477' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (398, N'c501dcef-002a-4a4b-475e-08dba2e5642c', 5, 2, 1, NULL, CAST(N'2023-08-22T08:00:35.477' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (399, N'3474ef24-01ab-493d-73b4-08dba3193f0b', 1, 1, 1, NULL, CAST(N'2023-08-22T14:08:42.287' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (400, N'3474ef24-01ab-493d-73b4-08dba3193f0b', 1, 2, 1, NULL, CAST(N'2023-08-22T14:08:42.287' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (401, N'3474ef24-01ab-493d-73b4-08dba3193f0b', 1, 3, 1, NULL, CAST(N'2023-08-22T14:08:42.287' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (402, N'3474ef24-01ab-493d-73b4-08dba3193f0b', 1, 4, 1, NULL, CAST(N'2023-08-22T14:08:42.287' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (403, N'3474ef24-01ab-493d-73b4-08dba3193f0b', 1, 5, 1, NULL, CAST(N'2023-08-22T14:08:42.287' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (404, N'3474ef24-01ab-493d-73b4-08dba3193f0b', 6, 1, 1, NULL, CAST(N'2023-08-22T14:08:42.287' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (405, N'3474ef24-01ab-493d-73b4-08dba3193f0b', 6, 2, 1, NULL, CAST(N'2023-08-22T14:08:42.287' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (406, N'3474ef24-01ab-493d-73b4-08dba3193f0b', 6, 3, 1, NULL, CAST(N'2023-08-22T14:08:42.287' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (407, N'3474ef24-01ab-493d-73b4-08dba3193f0b', 6, 4, 1, NULL, CAST(N'2023-08-22T14:08:42.287' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (408, N'3474ef24-01ab-493d-73b4-08dba3193f0b', 6, 5, 1, NULL, CAST(N'2023-08-22T14:08:42.287' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (409, N'a64b4287-bcd6-426f-bd06-14fea4f859e1', 5, 1, 1, NULL, CAST(N'2023-08-23T10:36:00.870' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (410, N'a64b4287-bcd6-426f-bd06-14fea4f859e1', 5, 2, 1, NULL, CAST(N'2023-08-23T10:36:00.870' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (411, N'a64b4287-bcd6-426f-bd06-14fea4f859e1', 5, 3, 1, NULL, CAST(N'2023-08-23T10:36:00.870' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (412, N'a64b4287-bcd6-426f-bd06-14fea4f859e1', 5, 4, 1, NULL, CAST(N'2023-08-23T10:36:00.870' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (413, N'a64b4287-bcd6-426f-bd06-14fea4f859e1', 5, 5, 1, NULL, CAST(N'2023-08-23T10:36:00.870' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (414, N'a64b4287-bcd6-426f-bd06-14fea4f859e1', 6, 1, 1, NULL, CAST(N'2023-08-23T10:36:00.870' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (415, N'a64b4287-bcd6-426f-bd06-14fea4f859e1', 6, 2, 1, NULL, CAST(N'2023-08-23T10:36:00.870' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (416, N'a64b4287-bcd6-426f-bd06-14fea4f859e1', 6, 3, 1, NULL, CAST(N'2023-08-23T10:36:00.870' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (417, N'a64b4287-bcd6-426f-bd06-14fea4f859e1', 6, 4, 1, NULL, CAST(N'2023-08-23T10:36:00.870' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (418, N'a64b4287-bcd6-426f-bd06-14fea4f859e1', 6, 5, 1, NULL, CAST(N'2023-08-23T10:36:00.870' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (419, N'b0c6046d-78cb-4d11-ea82-08db9a411e49', 3, 1, 1, NULL, CAST(N'2023-10-30T10:34:20.233' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (420, N'b0c6046d-78cb-4d11-ea82-08db9a411e49', 7, 1, 1, NULL, CAST(N'2023-10-30T10:34:20.233' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (421, N'b0c6046d-78cb-4d11-ea82-08db9a411e49', 5, 2, 1, NULL, CAST(N'2023-10-30T10:34:20.233' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (422, N'b0c6046d-78cb-4d11-ea82-08db9a411e49', 9, 4, 1, NULL, CAST(N'2023-10-30T10:34:20.233' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (423, N'b0c6046d-78cb-4d11-ea82-08db9a411e49', 1, 4, 1, NULL, CAST(N'2023-10-30T10:34:20.233' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (424, N'b0c6046d-78cb-4d11-ea82-08db9a411e49', 2, 1, 1, NULL, CAST(N'2023-10-30T10:34:20.233' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (425, N'b0c6046d-78cb-4d11-ea82-08db9a411e49', 4, 1, 1, NULL, CAST(N'2023-10-30T10:34:20.233' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (426, N'b0c6046d-78cb-4d11-ea82-08db9a411e49', 6, 1, 1, NULL, CAST(N'2023-10-30T10:34:20.233' AS DateTime))
INSERT [UserManagement].[RolesPrivileges] ([Id], [RolesFkId], [NavigationMenusFkId], [PrivilegeActionsFkId], [IsActive], [CreatedBy], [CreatedDate]) VALUES (427, N'b0c6046d-78cb-4d11-ea82-08db9a411e49', 8, 4, 1, NULL, CAST(N'2023-10-30T10:34:20.233' AS DateTime))
SET IDENTITY_INSERT [UserManagement].[RolesPrivileges] OFF
GO
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'96d28f37-a1f0-4599-8a71-00d3e9b264a7', 11, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e0de9f2a-3fb8-47d3-9ad2-0321a3cd9dd0', 16, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'9a94d4b0-8fa6-4c0d-b571-0398bab646ec', 3, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'bb28054b-6760-4f1f-a58a-03bfd095b465', 2, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'76b1e40f-3c18-4f47-85b6-048d33f3b678', 3, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a6ec3c56-ef97-4beb-9753-049ec72b6b04', 9, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'f4a18fb8-70ce-4412-ad79-04b1a5fc682c', 2, 2, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', 1, 0, 1, 1, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', CAST(N'2023-08-23T10:07:18.470' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'b41ba0f5-16a4-4b33-bb3b-06688f7136a2', 5, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'4f09dcae-2df0-4bf5-ac7e-07c41624ebf8', 4, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'aba53355-771c-45e4-9798-09b517e1debc', 13, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e87c9d65-427a-4a77-a7be-09b5dbcb803d', 11, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'fda43cd5-1727-41da-acb7-09f1355bccff', 12, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'bc820ea2-4045-48b4-8175-09f36d36d329', 16, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a0acc1e8-c69b-40cd-97d4-0a54914b6ec8', 3, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a4a0f4aa-5c84-4da5-a9f8-0aa87d56c743', 4, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'eca22214-3cde-4c26-82f0-0b63e223a94f', 3, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'4b1f2c73-753d-4956-b547-0c4224412a92', 6, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'b99b41ef-915f-4bb1-8683-0c46a0b4c803', 6, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'fd0dc207-35e8-40fe-8b09-0d17b320775e', 1, 1, N'bececce2-8a69-42c5-31f8-08db9c95ac0a', 1, 0, 1, 1, N'bececce2-8a69-42c5-31f8-08db9c95ac0a', CAST(N'2023-08-16T14:03:12.957' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'41550a63-ba24-4428-b8d6-0decbadab498', 9, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'927d4192-5d8e-4cd6-bea3-0df364477a2c', 4, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'98370904-d60a-4503-bfa1-0df99c26a5c1', 11, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'2384f6c0-d2ef-46b6-b85f-0e36c3b219eb', 8, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ff6a7377-097e-4771-8a61-0f0eef38d8c2', 7, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ddf220cb-fa00-4075-9bdd-106c6ae9cddf', 15, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'87cb2969-c204-40a7-84e9-1109f9c5bc73', 4, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'464db202-9c0e-4afe-8d74-1146e535055f', 10, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'6b763e80-ebc7-48ea-abf9-118fec701c25', 16, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'48613f26-ae5f-4e7a-8eae-12455d225221', 15, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'320cef26-4bca-41b2-a771-12988bb0fc9f', 12, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'1a542e06-0799-4216-9cc4-13141f92532d', 16, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'4a40a27a-0c51-48a3-bc76-138e912ecc8e', 10, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a202b226-b6e3-4bf7-9501-13fdf2c4ff18', 14, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'dbc6e76e-8a82-4aa6-a0c9-187538de7026', 14, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'3a0d3317-71d5-49e4-964b-19106304264a', 8, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'77bbb374-d274-4a0a-87ac-1a211ba0ce5a', 2, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd18a9c84-11d7-428e-925a-1a3c28098d53', 7, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'2709c150-7921-46da-97e1-1aac2af85678', 9, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e215a850-cc4c-450c-b3b0-1b760ebc8884', 13, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'471c31b8-bb5c-4046-ac20-1cd405795678', 3, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'8bd7100b-77be-4fe0-a6c0-1d9d5fdba179', 16, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ed790ff8-cc89-4b23-a3c2-1d9de616c17c', 13, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'65187720-1747-4257-af47-1dbacf511a6a', 1, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'33e22327-ecba-41a5-ae44-1dfcf7e3b1b3', 10, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5afe4d44-9f65-4a61-bd14-1eb242276e18', 7, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'472d48f3-0905-42fc-b670-1efbb23a4c9f', 12, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'1192e646-fcec-4ad7-ac1c-1f69645b8cda', 6, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7dae0311-f1bd-4ba9-a6bb-1f8771cd9516', 14, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ae106178-4445-4997-a225-1fc267b6a977', 3, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'bf610bb0-bb4f-4e1f-8dee-1fe4a61fa809', 5, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'45549040-ed7c-4bdb-88fd-22f730b69a53', 2, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'77917bd4-52cb-49f0-92a1-2366da134977', 9, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'b07c19bf-f52e-4be9-9c7a-2366e3ef5971', 8, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'da2e935c-3cf5-47e8-97be-24ccf5ec722c', 1, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'77493ef3-19b5-4296-b6be-24e9d5e95e5b', 5, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd2474192-19a2-4234-8c39-25063a46c278', 14, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5b14fa11-6158-4dc7-9b2d-2677d20e4b8d', 16, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'2f4a1495-d479-4194-918a-289c3b276d40', 9, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'781f012e-0c0f-4f3c-af72-29a2d7bcbcac', 16, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'91523a11-aa37-4a01-9000-2a34e3313232', 13, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'84e1a9e3-3f44-46b2-9e31-2ce35d5a973d', 15, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'8b4e1167-f7ee-451b-984c-2d6f7bbc567b', 6, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'00c1b6dd-a9ac-444a-b413-3007d34634ce', 7, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'cc183413-f512-4478-bea4-3066f17a1de5', 5, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'98404f82-37d6-4261-b0a4-3080fdc2f6a9', 14, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'0b8ae3a5-adc5-4f46-a5f8-30f4aab8ca03', 5, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7c3d446b-f4f4-44fc-8bff-30fd83a88e13', 8, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'cffd78cd-bac4-45b4-9fe7-3289440f0f2d', 4, 3, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', 1, 0, 1, 1, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', CAST(N'2023-08-23T10:07:18.470' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'02fa802a-5c5b-4758-a6af-32ba3495f818', 7, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'de145452-245c-4d77-bad7-33f88b354920', 15, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'167f313d-3463-47c2-be00-351241cfdb73', 1, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'88ea60d7-11d4-49d2-9c0d-35d92d639a2a', 12, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ba226ce9-4c8e-4385-a87f-35e304216ff7', 7, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a2ec0108-6932-4dc2-93f0-3649ba8cf63a', 6, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5c9dd4a2-9996-4c4d-b274-367ad329190e', 3, 2, N'34a938d7-3fc6-4512-5cc6-08db9ed9ecd5', 1, 0, 1, 1, N'34a938d7-3fc6-4512-5cc6-08db9ed9ecd5', CAST(N'2023-08-17T12:47:43.670' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'4a84e678-c329-4201-b201-38b72ec32767', 2, 1, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', 1, 0, 1, 1, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', CAST(N'2023-08-23T10:07:18.470' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd5f9d96b-d937-4825-8b77-38bc47efeca6', 9, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'0f457235-4bf6-4268-b4d7-390086ff85c8', 6, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'93354a17-358f-476a-b16a-3a0623f5ba87', 6, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5facdb40-728e-409d-a8b8-3b3b016da911', 5, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'0f3b09d3-5c82-41ce-8f5d-3b8241a50da4', 6, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'bbf9831e-3b51-4874-83f4-3b8831a81f0b', 13, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd1b30638-6363-4235-8165-3d5c0bee5da4', 2, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7251b8c8-1e35-4fca-94e1-3d892ccc0d5c', 14, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'1867183c-3b81-4377-91e7-3d8f8f53860e', 9, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ea2dde6c-0f13-4388-b7d5-3da83fd3339e', 10, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'b1aeef14-2ee7-43c0-aadc-3de7271d5d35', 8, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'294ab051-5d0d-4967-bf42-3df09ff607dc', 1, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'36ba129b-d933-489d-83de-3df19a547229', 5, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e4fc0ec4-1f71-4da8-8e2d-3ecf507500a2', 16, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'4c2cfb80-a578-48d8-8a4b-3f01a0140142', 10, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'73f3cee5-f9fa-4fe0-b64e-3f27ebbe9975', 1, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'54b02045-75df-472f-82a9-3f33e65c5eca', 8, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'c68afbd2-90a8-4372-9c76-3fbb8961cffe', 13, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e769b179-5d37-4083-b870-40ceac76da18', 6, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'43269ade-381b-4097-b914-429155408f72', 2, 4, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', 1, 0, 1, 1, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', CAST(N'2023-08-23T10:07:18.470' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'537d988a-9d62-43df-9f99-429514494fb9', 4, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'1e713851-b62b-4827-a1dc-4325f731699a', 12, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'07fc7def-38ef-437f-b94d-456558fd6521', 8, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'498602ce-c349-4956-b993-46149dd50e02', 11, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
GO
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'48492fc3-342a-423a-9678-476bb66625ec', 6, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'145503ce-4fe7-4769-90d9-477367e4da36', 12, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'47d0bac2-8c8e-40eb-be4d-48a383233bdc', 14, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'eb113cb0-cf31-4d50-bd4a-48b65bdfb7e1', 9, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'1955f4a4-65e2-4ce2-b33b-4a751f230443', 5, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'780720d4-8c5e-4641-acb9-4c2b6c4c5d37', 14, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'84afc10d-8cf8-4ca9-b973-4cda75386868', 11, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'83d57120-d596-4241-bad9-4e4c0e2c4d5f', 10, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'79fa75ab-6dd4-4fae-bfcc-4f761f12fa13', 6, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'f7a3de7f-37aa-4ae5-ae02-4fbb921086b9', 6, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'53e48a6f-a9c0-4aeb-a2e4-4fc590303480', 11, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'b671e24d-bd78-4eca-b9e7-50fd70c025c3', 7, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'1f6d0bbb-ac1d-4e0f-a6d3-5120c49a27d8', 4, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a4bd490f-19f6-41be-b384-529881ec7ce4', 7, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'340018fa-7ef4-43c5-a055-53031f124b9b', 15, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e7392f22-8d92-4c73-b9b8-531e7a7710f3', 14, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'35dd8e16-2dc3-4d30-9ac9-53dc594886da', 16, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'bcb050f6-1886-4554-a1e4-5510098b44af', 15, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a46ab711-e4a2-4887-add8-5566ea012181', 10, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd15879f4-1776-47f0-b7d3-55b38f2dadd6', 16, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e5d1f512-1e7a-4a10-85e9-5606273c7228', 1, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'646f9b6c-f2ec-4a08-a816-56ebb454ed49', 11, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5a9f23e9-4efa-4746-8ec1-589fc490096c', 7, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'80abef18-8773-439a-ab09-59938f3b2160', 16, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a15236c9-463d-467a-840a-5a55ce252b77', 9, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'556156f7-1767-4554-9045-5cc47b7c8f17', 10, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e6d35846-9b3b-4afd-9354-5ea553e53830', 8, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'9865c93f-abed-4c7a-a9a9-5f38b26238ba', 10, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd2f0a3b6-5d09-4230-ab47-60603083daf6', 1, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'23a8fb29-4a7b-423f-9646-61a18b028317', 15, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'08dff5c9-7946-4079-ad51-62341c98037a', 1, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'cebe0ed6-7c90-44f6-a241-62b2eddae0c3', 11, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'c92fd1ae-4da5-42a6-9238-6313804accc2', 1, 1, N'34a938d7-3fc6-4512-5cc6-08db9ed9ecd5', 1, 1, 0, 1, N'34a938d7-3fc6-4512-5cc6-08db9ed9ecd5', CAST(N'2023-08-17T12:47:43.670' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'580faccf-8a02-441e-82d0-631e21498978', 3, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'3fd6b0df-83c9-4e25-9078-63c0bf256601', 13, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e1d63666-8110-4917-997c-641845be6352', 4, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e32f873e-b572-4b4b-adf4-64508b2a72fe', 2, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ffa1b839-221d-4c79-8e7d-64949ac3c9b4', 16, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'caba19fe-0d94-473a-9a71-64ad70873b3a', 2, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7d1db6e9-c436-4983-b450-656bbd02618d', 15, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'56a44b05-0385-4b2c-9a98-65e0baf510cb', 13, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'c90fef22-ace4-46a5-b2e2-6613ac9da80f', 5, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'de1311f5-909e-4851-adb3-68e7593cc249', 3, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'be49e066-9898-4c8c-8fc0-69323c80ffbb', 10, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e905aa59-9dcd-4f07-8d67-6a206a74f692', 5, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'2fef47af-8383-4af7-9be6-6aacf64e9b0f', 1, 2, N'34a938d7-3fc6-4512-5cc6-08db9ed9ecd5', 1, 0, 1, 1, N'34a938d7-3fc6-4512-5cc6-08db9ed9ecd5', CAST(N'2023-08-17T12:47:43.670' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'f8268ea9-90bf-493d-bbbf-6ad235ee233b', 9, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'f0612af9-2f44-419f-847d-6b9086f76957', 7, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'73aeb001-aa84-4c5e-815e-6d3f71180c6b', 4, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'8e7a6261-c29d-4aa7-bec3-6d44baae2f83', 16, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ebb1e520-f29f-4569-8b82-6d4aa7893c83', 16, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'38819378-5726-45e1-8938-6e5e588d739d', 12, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd5d83093-7322-4357-8541-6e91230e98f0', 15, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'87ee1278-ef1d-4efe-b9c3-6fe3f96eefdf', 16, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7a97f089-7f5f-4603-8790-70671378b568', 14, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'3818cea1-d043-4fa6-9c24-70acc4798ddc', 14, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'6f3d39ca-ec50-45b9-a760-70b2a9ed2785', 14, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'0394bdbf-32e7-4dbe-9d7b-71da581de874', 2, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a3a767f8-3a18-4446-b8a6-7242db208beb', 9, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7db43b0d-3987-4e4d-a544-72e850c4de68', 10, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'63cab909-3210-461e-852a-736e3f877a4f', 6, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'496dd36f-0881-478e-89ce-7386f6200e04', 13, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd211c22c-dfc7-4853-acec-7463f2b9358f', 13, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'54c2f5f6-92bc-49e2-aa15-74af41174af4', 4, 4, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', 1, 0, 1, 1, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', CAST(N'2023-08-23T10:07:18.470' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e0cd52ed-f937-4e0b-8c2f-751dcc5948f1', 4, 1, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', 1, 0, 1, 1, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', CAST(N'2023-08-23T10:07:18.470' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'87f25d18-d4d6-495a-b87c-75b2f47fc38e', 10, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'09b81203-82b7-4f10-a570-76863621e084', 14, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd0828a35-6ef1-4898-83f1-7694d34ab1a5', 2, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a00dfe16-6a4f-4df1-97cd-76cf11c4ee26', 10, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7a61b72d-2ec3-4d2e-91d1-78acdc86a48d', 15, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'3e304642-542c-4191-b062-78c1359f22a8', 3, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'94bb2a1e-b3e1-4811-a012-7b3afd5416c2', 5, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'789cda82-5321-4295-80b3-7bb346b1a290', 9, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ca08bc3d-2bea-46d8-a3b8-7c94e67bd321', 9, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ed5ba404-5228-46e2-bba2-7d4c6117aa94', 1, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'55d37ee8-68e1-48af-8314-7d93b367bbc8', 5, 2, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', 1, 0, 1, 1, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', CAST(N'2023-08-23T10:07:18.470' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'0ed726ac-fff1-421d-abb5-7dc7a5be5dfd', 1, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'79fa41de-59a2-4442-aac0-7e031b46f0b7', 14, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'24691a48-ccb4-4707-8ca0-7e1768a4c222', 6, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'98b5594b-d436-4512-9755-7e7e426432e2', 3, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'eda2cc41-d541-423b-b5ec-7ebe0bf2292f', 2, 4, N'34a938d7-3fc6-4512-5cc6-08db9ed9ecd5', 1, 0, 1, 1, N'34a938d7-3fc6-4512-5cc6-08db9ed9ecd5', CAST(N'2023-08-17T12:47:43.670' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'bc97611c-2f7b-4274-aa47-7ee0a4327196', 3, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5727a783-3117-4991-8134-7eedd62edc2f', 1, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ddcf60d0-eb61-46a3-ad38-807bdf21a874', 2, 5, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', 1, 0, 1, 1, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', CAST(N'2023-08-23T10:07:18.470' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'4c440e98-ea0d-46fb-87e1-817c2baecda6', 3, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7b89cf04-ab2f-44d6-9f98-8241d2877660', 8, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'df1fadb6-8c7e-472f-8b45-83951fd49fd8', 8, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'fbfd28e4-5bd2-4318-ab4b-847c26609855', 3, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'10eacac0-eef4-4c06-9d0a-8555fd2e1c5e', 2, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd6755645-876e-465f-abb2-86a39d9768c3', 2, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'6b2088b1-2c72-4e1c-bde5-872d9fe5d8dc', 6, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'bfb0fefb-abbe-46d7-80ab-893258249139', 7, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'c7360dd2-4b4d-4ad8-9ae7-898840fc3019', 12, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd38199ef-11f7-4a9f-844e-8adedb5dde9b', 14, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'89b4af7b-e488-4516-8e3f-8bac6106d522', 3, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'8fce19a3-c226-4756-b59b-8c4d94dda080', 15, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'b0a8ccb5-7b80-42db-9307-8ff1774964b8', 14, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'8b5a1bd7-cbfa-4ae9-b71d-8ffb0435e558', 15, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'24f63620-1e7f-4d68-b5a9-90100ded4399', 8, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'21ed2d9e-dada-444a-b497-916ce960c69c', 3, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
GO
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'05eb03ef-26f5-43c5-accb-92731164c9bf', 7, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'cc0b0cc3-ae0f-4135-a187-92a2f3db2660', 15, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'70d5f932-5c59-429e-8b2a-92f3f007ab93', 4, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'969473e9-c125-490e-9eb8-92f5361a58e1', 10, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'87396c2a-0e96-42ea-9eb5-93a3c8d0f565', 15, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'465a8b66-df7b-45a3-a4ac-93ebeb8b4e3e', 8, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'dab872d7-e12f-43be-8cba-941a0ffc5d34', 7, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'0383de6f-7aac-45c7-a6f8-9423ca44b91c', 13, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'40814470-a854-4f05-97b1-949d291948f7', 15, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e69b160f-9d28-4121-be73-95084b393883', 8, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'41289203-fcb3-4744-ace0-9627f97e1c56', 12, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'9b0904ca-c5f4-40dd-b984-9665fb994d2e', 15, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd535456b-a5d7-47f4-95ef-97638e72cf86', 4, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'aa7ffa14-8fb5-4c1c-9478-97774a3a8b93', 6, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'12c93b2c-f2c0-424e-bd88-97a64222096e', 5, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'6091f19f-b0b4-4905-8a8a-97b79af7ba30', 12, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a84e79a0-0118-47c3-9522-98a9c6100150', 3, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a60dbb50-5e55-4567-b7b3-99546914366f', 5, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'641ea999-a70e-49b8-b83f-997321b6487c', 15, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'1b20c938-a15a-4d4f-91b7-9b21166a3df4', 10, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'fa1f7eb0-609a-432e-a7d1-9b69f0db3d6e', 16, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'76c0410b-0872-406f-8294-9bdcbf522c1d', 11, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'dfd312dc-dbfa-427b-aa29-9c824192c21a', 6, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'f9f6a648-dee4-4f86-b3b7-9c9be7ec7ba9', 11, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'c58ac342-116d-4970-9808-9d524b41a45f', 12, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'44b50953-3943-45ce-9e94-9e7b241310d3', 3, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'83c2e64c-9f82-4b0e-8262-9f7206db3ba6', 2, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'4a5d4e53-be6f-492c-bcc0-a02d573aa39d', 7, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'0c7187dd-057f-4242-bf1a-a0d37d742129', 15, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'c5f06068-1780-4c5a-94fd-a20c58ba3407', 4, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'460b590b-e1e2-402e-83da-a26103afdbc2', 16, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'8e7438e9-dfc1-47e7-a8be-a302c93bfd89', 12, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'9b26a4f9-4f3b-4180-875a-a307446d457e', 13, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'0be57a8c-1ea8-4ce2-9641-a34a6274b4ff', 12, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'75c0cd7a-922f-4b04-ba02-a34d5db02268', 7, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a1a5be05-0fa9-4e19-b6dd-a3e8e8012aaa', 11, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'73c92ae2-4a28-4be3-9aa7-a4db997d1cf0', 11, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'26247fd6-1390-472b-b02f-a50004b2c689', 6, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'cf615cc8-d3e4-45ae-810d-a5ce70ff399d', 1, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7696eb47-4aff-49bb-b535-a5d65a0a3bc8', 4, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e0995445-97b3-4c62-b1f7-a6ca981304bf', 5, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'1bb6e976-8552-4b25-a231-a89c4a6208ec', 2, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'66341e60-83f3-4777-9019-a9f04365be90', 1, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'c6787418-f15d-4deb-90c4-aa07074871b8', 7, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'6dd8e01b-0439-42d0-8a7e-abfe64e7418e', 4, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7b726f2f-9488-4372-9622-ac8bc79193ea', 12, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'458cf3f1-9238-4e12-9e6b-aca0163c395f', 15, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ed0aef67-dd4f-41aa-b212-ae09aaf177e7', 9, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'4332cdf3-493f-4a1a-997b-af217f803b92', 10, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'c417963d-c253-43e5-bda6-afc3bde61396', 4, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'97978945-0171-4025-b39c-b04f9ab2d33f', 1, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'3ff0a7a4-aa4e-468f-87e4-b3471e3f9e16', 13, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'8955b139-39ef-4d77-8e1f-b42278724d26', 4, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'be034800-d65d-414e-92ce-b42beceb6b40', 6, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'3e28d6c4-dddd-4603-9063-b47d2fe47557', 10, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'78a82d6f-e333-483a-9b9e-b4b164050df4', 11, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'99357d16-4b69-4252-876b-b5801142219e', 4, 2, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', 1, 0, 1, 1, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', CAST(N'2023-08-23T10:07:18.470' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5bf48e52-ad7a-4b80-9020-b5bff19c5014', 2, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'cd92422a-2691-48b0-834a-b608df1a5b67', 16, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'2a08b502-1c93-4ef3-b940-b6509917df2c', 9, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd8265ec5-a1f7-42a9-b8fe-b67243b92541', 2, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'f82a03d4-3dc7-4c04-9486-b72b15d34c46', 10, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e3f66ca9-08e0-469a-8401-b731ceb489f2', 6, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'cd387455-84be-499b-8d69-b752251a139c', 10, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'125c4844-3510-4aa0-8d25-b7e5c32e1536', 7, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'266011f7-a2cd-4bb9-bae4-b810e4039246', 7, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a30172b1-4886-4411-9e73-b8cd6eb09431', 10, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'762acafe-aeaf-4bc0-b877-b8d95a8b5389', 9, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'143ea957-685e-4152-9980-b95974e3b56f', 16, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e3a97baa-d75d-4f3a-b08e-b980bdb62c74', 3, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'0de5d00c-7140-4fb1-b3c1-b988d3fa7c60', 16, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5c37b047-97eb-43ba-88ef-b9a7316359a5', 5, 2, N'34a938d7-3fc6-4512-5cc6-08db9ed9ecd5', 1, 0, 1, 1, N'34a938d7-3fc6-4512-5cc6-08db9ed9ecd5', CAST(N'2023-08-17T12:47:43.670' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5610889a-413d-427c-bb5a-b9dcef1c4a63', 16, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'83f2daa9-eb19-4858-ad28-baff7ea04447', 15, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'12610aac-6b25-45f9-85df-bb0b2bd32e62', 7, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ebddc7fc-cfc7-4b4f-a100-bb57f664212b', 16, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e37a0489-175e-4dde-b623-bbbd513959f0', 12, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'b2d9deb9-cad2-40d0-8623-bcb24b14c62d', 1, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7726da11-a59a-4ea9-8cde-bf7a035a3fb6', 11, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'4a196d1b-2f7b-421f-8433-bfc4cd077309', 3, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'622eff99-ca09-45ea-991d-c06c88f1ca7c', 4, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e6c75589-ba2e-4051-9a4e-c08befa8ad44', 3, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'f9171646-de15-4d38-b2e2-c1cb18c4d77c', 2, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5a2b571e-7554-4d2d-8264-c2036080a826', 9, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'2688bf77-3b09-4dd5-9603-c242aeb66d08', 7, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'9a1f54de-5e59-4353-ad80-c3448e8aa009', 1, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'1ec748b8-b5ba-4f78-8384-c397b4cd49ef', 8, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7b596333-81eb-4a11-9393-c3bfa8305a06', 12, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'b4053b80-eecb-49bf-a64a-c3c7dd2886c1', 13, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'f0057c4b-13f4-477f-b74a-c48ab64c0ad6', 2, 3, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', 1, 0, 1, 1, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', CAST(N'2023-08-23T10:07:18.470' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'b7b2f594-fc10-4c95-9bb6-c4b7356169b1', 1, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'9a96b911-bff6-4bc8-8f6b-c50cd8c701b7', 12, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'c5af799a-a289-41f5-9cb3-c7037a89ae10', 2, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7dcd87df-1841-47ab-98a5-c893640b142b', 2, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'038d9c56-0eb2-40d7-bbd9-cb7344bc264f', 8, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ed78ad0d-dcc6-4c85-ad9b-cbf9b91941b2', 8, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'aa69b8dd-078f-45d9-9da1-cc325b664aa7', 11, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a7b33b3d-541b-4368-be7a-ccd2e0f92472', 11, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5ea71a2c-57f9-44cf-b417-cdce4d6ae166', 15, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e47c5b02-ef97-47cb-995e-ce2addf88a1a', 14, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
GO
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'b61dc778-acf1-49ae-9b84-cf742a6b41fc', 9, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'9a8a8dc6-616a-40d8-971e-cf9901874112', 6, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'1c475339-2718-4e84-a05d-d00a92c83b7e', 1, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'2b758a48-b18f-44ad-9bde-d04eeb6825dc', 8, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'56a7c84d-90c3-4d33-aee3-d06800a57e0c', 11, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'6be9c495-bd72-4bef-9b63-d0b739903e7e', 9, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ae93edbc-2aaa-4ebd-9320-d0e09a9b638e', 12, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'8c36e39c-476a-4050-bacf-d29b3eaf0182', 13, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'bcd7c608-602e-4e04-aab3-d31661abb85d', 11, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'75131e6d-da46-4440-97cc-d33db79ab56d', 12, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5ef24e3e-dc31-4d6b-8f37-d3c0e1ba85db', 7, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ab5b2560-827d-4821-aa07-d3d073f2fc71', 9, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7f5c34e6-11da-47d6-85e9-d3d7d5a79e1f', 4, 2, N'34a938d7-3fc6-4512-5cc6-08db9ed9ecd5', 1, 0, 1, 1, N'34a938d7-3fc6-4512-5cc6-08db9ed9ecd5', CAST(N'2023-08-17T12:47:43.670' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'c5060d88-02d0-4428-a596-d3e5a49c9b66', 6, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'80fe2cdb-b9cc-423a-a07f-d4b9bbdee60b', 7, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5a5b1cc3-c349-4494-8034-d5d2063440d8', 1, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e86acb52-f24e-40a7-9d19-d604f5fab022', 5, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ee16390c-84b4-438e-8272-d608f4f3c238', 3, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'07b2c3d6-b776-41fa-9342-d68251e77362', 5, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ae7bdb3e-ffcf-481f-aaa0-d6a7c4078367', 5, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'033ea01a-2260-4909-960e-d6e7a859f2ea', 8, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5ac3e034-0ccd-41a6-ae6d-d750696b7586', 16, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'89cee5fe-e110-4035-8428-d7ca449b5269', 7, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'dc9094ae-a37f-4af4-89ae-d8fce0e35076', 10, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'2c230203-790d-40b6-89b5-d95c33f717cc', 11, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'cc6f77ba-0498-4360-888a-d9a06fbf9a93', 14, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5bf43110-d232-4f21-baae-d9c343697d97', 13, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'05359fae-30b2-4afa-97c9-da44bfbf1e7c', 4, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'02c70870-dbef-467f-9d55-da5ef62ead26', 11, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'452a40ea-05d1-4869-81ee-dad0a44eb023', 5, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd4adf21e-c272-41b7-8ca3-db8d0d19f1d6', 12, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'593b38b9-e7b1-4f02-9238-dc884c79d5a2', 8, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'b65771b1-a2d8-41b6-a7f3-dce44d90eda0', 1, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'6d621c18-2665-4d24-b828-ddcba5a90062', 13, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'de2fc83b-da17-44d6-ac42-de42cf8c7b27', 10, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'538ac8f9-4e8b-40ea-b2f0-deb2fdd3bcdd', 2, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd7bfc699-f1ae-400f-8487-dec86b6ba094', 2, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'9525a962-1606-41dc-ad80-df0bc0393cd6', 15, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'4f3cb0d6-576f-4ee4-abdf-dfac3df003a4', 14, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'1dc9893b-80a5-4dc5-8d56-dfb413e5099a', 6, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'4cde478e-b6b0-4695-954a-e0537c3ba271', 2, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'683676b4-c70b-48c9-923e-e204a9468926', 1, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'4f066c6e-a5df-48d7-b137-e2a2e31c43d8', 12, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd1d55f75-a0ac-4d84-b95e-e2e5de3a6b81', 14, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'16837850-a692-4bc1-8cec-e3b984195359', 1, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'028b401c-9392-4497-993c-e466c6dffdf1', 4, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'3a318a57-a90e-4e71-b4d9-e49d373adb0a', 4, 5, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', 1, 0, 1, 1, N'ccf74149-5b96-4216-3b48-08db9fa4fa24', CAST(N'2023-08-23T10:07:18.470' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'3a772987-b48d-4c5b-900d-e4c84bb9ecea', 16, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'06ea80c5-f2e0-4c6a-94a5-e4fdd435fc2f', 8, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'6585b647-0a0b-4902-b4c5-e522cb3dbd3e', 10, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'3c4096e8-a885-4f5f-9324-e56103afe2e7', 8, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'886e02ad-35bb-4778-bd96-e654eea5ad08', 14, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'd128423c-4778-47fd-9030-e668c8f60976', 12, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'b1e4ee9d-2ade-47c3-8f63-e7049424e70c', 13, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'55f4ff19-3c6f-40eb-a7e6-e7054c10b2ce', 2, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'91967f3b-6061-435a-b891-e75adfdde84b', 1, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'20b0d058-386d-48b6-8c55-e7fd8891d52d', 4, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'abe29599-5a50-4afd-90a8-e8fdaf353caa', 3, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'407d47dd-f2ea-4e65-8a37-e9de6845771a', 8, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'09a3b887-8b01-4568-a030-ea3f4e1e62f9', 5, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'7a4d5ff9-8aa4-44b8-a6f1-eab48a2b2dbb', 13, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'2f5f4951-29a3-4772-9af2-eb80bc15b386', 14, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'36804cc6-81aa-4d26-acc9-eb958d0835ee', 9, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'6e592bdc-911c-41eb-8f7b-ec481ac58a18', 9, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'624dd5a0-486c-4111-98ed-ec60b86bebd8', 8, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'2de0b599-eee6-49fb-bbe2-eeafa15975bc', 4, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'0b8405d5-4993-4305-b236-ef1e37b8c006', 6, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'4041ed63-d938-4500-9f5c-f0070183c766', 4, 5, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'9c18a939-e46e-47c5-89b9-f0bf728bb192', 12, 6, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'db8d4ac2-7269-4b81-a85e-f1c553b4874a', 2, 3, N'34a938d7-3fc6-4512-5cc6-08db9ed9ecd5', 1, 0, 1, 1, N'34a938d7-3fc6-4512-5cc6-08db9ed9ecd5', CAST(N'2023-08-17T12:47:43.670' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'2d768215-dba4-4007-897c-f1edb14deb41', 13, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'f4fb8393-0e90-4c65-bbf1-f244c9503bcf', 1, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ac00b1b7-3357-4c93-9826-f2be458e5b68', 15, 5, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'dbf76e35-9fd2-4cc9-9fbe-f3c9dee70c65', 11, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'8d969f0a-fdf9-42ce-8b67-f3f39973413c', 12, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'58e73e64-3b8a-4952-9516-f441edccaf89', 13, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'5fcd49ae-32bb-401e-9bf7-f5f591b442ae', 9, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'26b7d3fd-99d3-4855-879f-f6b7b40be01e', 5, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ab2f57a2-1718-4ed5-9a3a-f75ae17217de', 4, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'c59f79b4-84cb-4ec8-bf18-f84876495c42', 11, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'18154dbb-37c0-4b84-b20b-f8725fed4b2d', 13, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'a05f46f6-3d6f-4913-99cb-f9a745c14284', 14, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'6f3e5907-2a4b-45be-9bc3-fa4d9b89291e', 2, 4, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'db4da984-9d95-42a2-b029-fa5dc5f75daa', 8, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'f942bca0-0a69-4b2d-aeef-fb0001570bbd', 13, 3, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'bff2b04d-21db-4e28-8a37-fb498c980d30', 14, 6, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'f681a250-4aa5-4a72-bc37-fc3a97fb56f1', 10, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e3f1f211-13d3-407c-9c59-fd6cd1d5ed12', 9, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'3b56b611-ff40-4403-84d4-fe179aa9437d', 11, 2, N'e263c0ad-7903-4dbb-687b-08db9fbddbc1', 1, 1, 0, 1, NULL, CAST(N'2023-08-23T04:52:31.480' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'e4200258-8755-4216-bfc7-fe19838c9821', 15, 4, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'eb4d4434-02d8-4cb5-b606-fef8e7e783ca', 11, 2, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'9707fc6b-c190-4294-8909-ff51c39f5327', 13, 3, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', CAST(N'2023-08-22T08:02:37.180' AS DateTime))
INSERT [UserManagement].[UserPrivileges] ([Id], [NavigationMenusFkId], [PrivilegeActionsFkId], [UsersFkId], [IsTrue], [IsGranted], [IsDeny], [IsActive], [CreatedBy], [CreatedDate]) VALUES (N'ea8c0779-ee9f-4009-8be5-ffc2c81163ef', 7, 1, N'8196d118-3ce7-4d22-5cc5-08db9ed9ecd5', 1, 1, 0, 1, NULL, CAST(N'2023-08-22T08:02:37.180' AS DateTime))
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [AK_AspNetUsers_UserNameNUserType]    Script Date: 01-11-2023 16:48:14 ******/
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [AK_AspNetUsers_UserNameNUserType] UNIQUE NONCLUSTERED 
(
	[UserName] ASC,
	[UserType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUsers_UniqueEmailNUserType]    Script Date: 01-11-2023 16:48:14 ******/
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [IX_AspNetUsers_UniqueEmailNUserType] UNIQUE NONCLUSTERED 
(
	[Email] ASC,
	[UserType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUsers_UniquePhoneNumberNUserType]    Script Date: 01-11-2023 16:48:14 ******/
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [IX_AspNetUsers_UniquePhoneNumberNUserType] UNIQUE NONCLUSTERED 
(
	[PhoneNumber] ASC,
	[UserType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PK_QPLOG_Error]    Script Date: 01-11-2023 16:48:14 ******/
ALTER TABLE [dbo].[Error_Log] ADD  CONSTRAINT [PK_QPLOG_Error] PRIMARY KEY NONCLUSTERED 
(
	[ErrorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppUserSingInUpRequest] ADD  CONSTRAINT [DF_AppUserRegistrationRequest_RequestedOn]  DEFAULT (getdate()) FOR [RequestedOn]
GO
ALTER TABLE [dbo].[AspNetUser2FAEnabledSignIn] ADD  CONSTRAINT [DF_AspNetUser2FAEnabledSignIn_RequestedOn]  DEFAULT (getdate()) FOR [RequestedOn]
GO
ALTER TABLE [dbo].[AspNetUserRejection] ADD  CONSTRAINT [DF_AspNetUserRejection_RejectedOn]  DEFAULT (getutcdate()) FOR [RejectedOn]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [IsDeletedByUser_d]  DEFAULT ((0)) FOR [UserStatus]
GO
ALTER TABLE [dbo].[AspNetUsersEmailMobileVerification] ADD  CONSTRAINT [DF_AspNetUsersEmailMobileVerification_EmailVerificationDate]  DEFAULT (getdate()) FOR [RequestedOn]
GO
ALTER TABLE [dbo].[MasterTable] ADD  CONSTRAINT [DF_MasterTable_Show]  DEFAULT ((1)) FOR [Show]
GO
ALTER TABLE [dbo].[MasterTable] ADD  CONSTRAINT [DF_MasterTable_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[MasterTable] ADD  CONSTRAINT [DF_MasterTable_ModifiedOn]  DEFAULT (getdate()) FOR [ModifiedOn]
GO
ALTER TABLE [dbo].[Member] ADD  CONSTRAINT [DF_Member_MemLastLoginOn]  DEFAULT (getdate()) FOR [MemLastLoginOn]
GO
ALTER TABLE [dbo].[Member] ADD  CONSTRAINT [DF_Member_MemCreatedOn]  DEFAULT (getdate()) FOR [MemCreatedOn]
GO
ALTER TABLE [dbo].[Member] ADD  CONSTRAINT [DF_Member_IsLogin]  DEFAULT ((0)) FOR [IsLogin]
GO
ALTER TABLE [dbo].[MenuMaster] ADD  CONSTRAINT [DF_MenuMaster_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ParameterSetup] ADD  CONSTRAINT [DF_ParameterSetup_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[ParametersList] ADD  CONSTRAINT [DF_ParametersList_Show]  DEFAULT ((1)) FOR [Show]
GO
ALTER TABLE [dbo].[ParametersList] ADD  CONSTRAINT [DF_ParametersList_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[PeoplePrivileges] ADD  CONSTRAINT [DF_PeoplePrivileges_IsTrue]  DEFAULT ((1)) FOR [IsTrue]
GO
ALTER TABLE [dbo].[PeoplePrivileges] ADD  CONSTRAINT [DF_PeoplePrivileges_IsGranted]  DEFAULT ((1)) FOR [IsGranted]
GO
ALTER TABLE [dbo].[PeoplePrivileges] ADD  CONSTRAINT [DF_PeoplePrivileges_IsDeny]  DEFAULT ((0)) FOR [IsDeny]
GO
ALTER TABLE [dbo].[PeoplePrivileges] ADD  CONSTRAINT [DF_PeoplePrivileges_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[PeoplePrivileges] ADD  CONSTRAINT [DF_PeoplePrivileges_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PeoplePrivileges] ADD  CONSTRAINT [DF_PeoplePrivileges_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[PeopleRoles] ADD  CONSTRAINT [DF_PeopleRoles_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PeopleRoles] ADD  CONSTRAINT [DF_PeopleRoles_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Roles_IsEditable]  DEFAULT ((0)) FOR [IsEditable]
GO
ALTER TABLE [dbo].[TablesName] ADD  CONSTRAINT [DF_TablesName_IsForDeveloper]  DEFAULT ((0)) FOR [IsEditable]
GO
ALTER TABLE [dbo].[TablesName] ADD  CONSTRAINT [DF_TablesName_HierarchyLevel]  DEFAULT ((0)) FOR [HierarchyLevel]
GO
ALTER TABLE [dbo].[tblProjectDetail] ADD  CONSTRAINT [DF_tblProjectDetail_ReOpen]  DEFAULT ((0)) FOR [ReOpen]
GO
ALTER TABLE [dbo].[tblProjectDetail] ADD  CONSTRAINT [DF_tblProjectDetail_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[TeamManage] ADD  CONSTRAINT [DF_TeamManage_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [UserManagement].[UserPrivileges] ADD  CONSTRAINT [DF_UserPrivileges_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [UserManagement].[UserPrivileges] ADD  CONSTRAINT [DF_UMUserPrivileges_IsTrue]  DEFAULT ((1)) FOR [IsTrue]
GO
ALTER TABLE [UserManagement].[UserPrivileges] ADD  CONSTRAINT [DF_UMUserPrivileges_IsGranted]  DEFAULT ((1)) FOR [IsGranted]
GO
ALTER TABLE [UserManagement].[UserPrivileges] ADD  CONSTRAINT [DF_UMUserPrivileges_IsDeny]  DEFAULT ((0)) FOR [IsDeny]
GO
ALTER TABLE [UserManagement].[UserPrivileges] ADD  CONSTRAINT [DF_UMUserPrivileges_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [UserManagement].[UserPrivileges] ADD  CONSTRAINT [DF_UMUserPrivileges_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[AspNetRoleClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
GO
ALTER TABLE [dbo].[AspNetRoleClaims] CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserClaims_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers]
GO
ALTER TABLE [dbo].[AspNetUserProfile]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserProfile_AspNetUserProfile] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUserProfile] CHECK CONSTRAINT [FK_AspNetUserProfile_AspNetUserProfile]
GO
ALTER TABLE [dbo].[AspNetUserRejection]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRejection_AspNetUsers] FOREIGN KEY([AspNetUserFkId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUserRejection] CHECK CONSTRAINT [FK_AspNetUserRejection_AspNetUsers]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetRoles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers]
GO
ALTER TABLE [dbo].[AspNetUsers]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUsers_AspNetUsersStatus] FOREIGN KEY([UserStatus])
REFERENCES [dbo].[AspNetUsersStatus] ([Id])
GO
ALTER TABLE [dbo].[AspNetUsers] CHECK CONSTRAINT [FK_AspNetUsers_AspNetUsersStatus]
GO
ALTER TABLE [dbo].[AspNetUsers]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUsers_AspNetUsersTypes] FOREIGN KEY([UserType])
REFERENCES [dbo].[AspNetUsersTypes] ([Id])
GO
ALTER TABLE [dbo].[AspNetUsers] CHECK CONSTRAINT [FK_AspNetUsers_AspNetUsersTypes]
GO
ALTER TABLE [dbo].[AspNetUsersDetail]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserInfo_AspNetUsers] FOREIGN KEY([AspNetUsersFkId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUsersDetail] CHECK CONSTRAINT [FK_AspNetUserInfo_AspNetUsers]
GO
ALTER TABLE [dbo].[AspNetUsersEmailMobileVerification]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUsersEmailMobileVerification_AspNetUsersVerificationTypes] FOREIGN KEY([VerificationForFkId])
REFERENCES [dbo].[AspNetUsersVerificationTypes] ([Id])
GO
ALTER TABLE [dbo].[AspNetUsersEmailMobileVerification] CHECK CONSTRAINT [FK_AspNetUsersEmailMobileVerification_AspNetUsersVerificationTypes]
GO
ALTER TABLE [dbo].[AspNetUserSetPassword]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserSetPassword_AspNetUsers] FOREIGN KEY([AspNetUserFkId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUserSetPassword] CHECK CONSTRAINT [FK_AspNetUserSetPassword_AspNetUsers]
GO
ALTER TABLE [dbo].[Branch]  WITH CHECK ADD  CONSTRAINT [FK_Branch_MST_Company] FOREIGN KEY([Com_Code_Fk_Id])
REFERENCES [dbo].[MST_Company] ([CompanyId])
GO
ALTER TABLE [dbo].[Branch] CHECK CONSTRAINT [FK_Branch_MST_Company]
GO
ALTER TABLE [dbo].[Error_Log]  WITH CHECK ADD  CONSTRAINT [FK_Error_Log_Member] FOREIGN KEY([Member_FK_Id])
REFERENCES [dbo].[Member] ([MemID])
GO
ALTER TABLE [dbo].[Error_Log] CHECK CONSTRAINT [FK_Error_Log_Member]
GO
ALTER TABLE [dbo].[MasterTable]  WITH CHECK ADD  CONSTRAINT [FK_MasterTable_MaterTable] FOREIGN KEY([ParentId])
REFERENCES [dbo].[MasterTable] ([Id])
GO
ALTER TABLE [dbo].[MasterTable] CHECK CONSTRAINT [FK_MasterTable_MaterTable]
GO
ALTER TABLE [dbo].[MasterTable]  WITH CHECK ADD  CONSTRAINT [FK_MasterTable_TableName] FOREIGN KEY([TypeId])
REFERENCES [dbo].[TablesName] ([Id])
GO
ALTER TABLE [dbo].[MasterTable] CHECK CONSTRAINT [FK_MasterTable_TableName]
GO
ALTER TABLE [dbo].[Member]  WITH CHECK ADD  CONSTRAINT [FK_Member_MasterTable1] FOREIGN KEY([MemStatus_FK_Id])
REFERENCES [dbo].[MasterTable] ([Id])
GO
ALTER TABLE [dbo].[Member] CHECK CONSTRAINT [FK_Member_MasterTable1]
GO
ALTER TABLE [dbo].[Member]  WITH CHECK ADD  CONSTRAINT [FK_Member_SROOM] FOREIGN KEY([SROOM])
REFERENCES [dbo].[SROOM] ([SROOM])
GO
ALTER TABLE [dbo].[Member] CHECK CONSTRAINT [FK_Member_SROOM]
GO
ALTER TABLE [dbo].[MenuMaster]  WITH CHECK ADD  CONSTRAINT [FK_MenuMaster_MenuMaster1] FOREIGN KEY([Id])
REFERENCES [dbo].[MenuMaster] ([Id])
GO
ALTER TABLE [dbo].[MenuMaster] CHECK CONSTRAINT [FK_MenuMaster_MenuMaster1]
GO
ALTER TABLE [dbo].[ParameterSetup]  WITH CHECK ADD  CONSTRAINT [FK_ParameterSetup_DefaultSqlDataTypes_DataTypes] FOREIGN KEY([FieldDataType])
REFERENCES [dbo].[DefaultSqlDataTypes] ([Id])
GO
ALTER TABLE [dbo].[ParameterSetup] CHECK CONSTRAINT [FK_ParameterSetup_DefaultSqlDataTypes_DataTypes]
GO
ALTER TABLE [dbo].[ParameterSetup]  WITH CHECK ADD  CONSTRAINT [FK_ParameterSetup_TablesName] FOREIGN KEY([TablesName_FK_Id])
REFERENCES [dbo].[TablesName] ([Id])
GO
ALTER TABLE [dbo].[ParameterSetup] CHECK CONSTRAINT [FK_ParameterSetup_TablesName]
GO
ALTER TABLE [dbo].[ParameterSetup]  WITH CHECK ADD  CONSTRAINT [FK_ParameterSetup_TablesName1] FOREIGN KEY([ForeignKeyTable_FK_Id])
REFERENCES [dbo].[TablesName] ([Id])
GO
ALTER TABLE [dbo].[ParameterSetup] CHECK CONSTRAINT [FK_ParameterSetup_TablesName1]
GO
ALTER TABLE [dbo].[PeoplePrivileges]  WITH CHECK ADD  CONSTRAINT [FK_PeoplePrivileges_Member] FOREIGN KEY([People_FK_Id])
REFERENCES [dbo].[Member] ([MemID])
GO
ALTER TABLE [dbo].[PeoplePrivileges] CHECK CONSTRAINT [FK_PeoplePrivileges_Member]
GO
ALTER TABLE [dbo].[PeoplePrivileges]  WITH CHECK ADD  CONSTRAINT [FK_PeoplePrivileges_MenuMaster] FOREIGN KEY([Page_FK_Id])
REFERENCES [dbo].[MenuMaster] ([Id])
GO
ALTER TABLE [dbo].[PeoplePrivileges] CHECK CONSTRAINT [FK_PeoplePrivileges_MenuMaster]
GO
ALTER TABLE [dbo].[PeoplePrivileges]  WITH CHECK ADD  CONSTRAINT [FK_PeoplePrivileges_PrivilegeActions] FOREIGN KEY([Privilege_FK_Id])
REFERENCES [dbo].[PrivilegeActions] ([Id])
GO
ALTER TABLE [dbo].[PeoplePrivileges] CHECK CONSTRAINT [FK_PeoplePrivileges_PrivilegeActions]
GO
ALTER TABLE [dbo].[PeopleRoles]  WITH CHECK ADD  CONSTRAINT [FK_PeopleRoles_Member] FOREIGN KEY([People_FK_Id])
REFERENCES [dbo].[Member] ([MemID])
GO
ALTER TABLE [dbo].[PeopleRoles] CHECK CONSTRAINT [FK_PeopleRoles_Member]
GO
ALTER TABLE [dbo].[PeopleRoles]  WITH CHECK ADD  CONSTRAINT [FK_PeopleRoles_Roles] FOREIGN KEY([Role_FK_Id])
REFERENCES [dbo].[Roles] ([Id])
GO
ALTER TABLE [dbo].[PeopleRoles] CHECK CONSTRAINT [FK_PeopleRoles_Roles]
GO
ALTER TABLE [dbo].[RolesPrivileges]  WITH CHECK ADD  CONSTRAINT [FK_RolesPrivileges_PrivilegeActions] FOREIGN KEY([Privilege_FK_Id])
REFERENCES [dbo].[PrivilegeActions] ([Id])
GO
ALTER TABLE [dbo].[RolesPrivileges] CHECK CONSTRAINT [FK_RolesPrivileges_PrivilegeActions]
GO
ALTER TABLE [dbo].[RolesPrivileges]  WITH CHECK ADD  CONSTRAINT [FK_RolesPrivileges_Roles] FOREIGN KEY([Role_FK_Id])
REFERENCES [dbo].[Roles] ([Id])
GO
ALTER TABLE [dbo].[RolesPrivileges] CHECK CONSTRAINT [FK_RolesPrivileges_Roles]
GO
ALTER TABLE [dbo].[tblAssetAction]  WITH CHECK ADD  CONSTRAINT [FK_tblAssetAction_tblAssetStock] FOREIGN KEY([AssetStockId])
REFERENCES [dbo].[tblAssetStock] ([AssetStockId])
GO
ALTER TABLE [dbo].[tblAssetAction] CHECK CONSTRAINT [FK_tblAssetAction_tblAssetStock]
GO
ALTER TABLE [dbo].[tblAssetBrand]  WITH CHECK ADD  CONSTRAINT [FK_tblAssetBrand_tblAssetCategory] FOREIGN KEY([AssetCategoryId])
REFERENCES [dbo].[tblAssetCategory] ([AssetCategoryId])
GO
ALTER TABLE [dbo].[tblAssetBrand] CHECK CONSTRAINT [FK_tblAssetBrand_tblAssetCategory]
GO
ALTER TABLE [dbo].[tblAssetBrand]  WITH CHECK ADD  CONSTRAINT [FK_tblAssetBrand_tblAssetType] FOREIGN KEY([AssetTypeId])
REFERENCES [dbo].[tblAssetType] ([AssetTypeId])
GO
ALTER TABLE [dbo].[tblAssetBrand] CHECK CONSTRAINT [FK_tblAssetBrand_tblAssetType]
GO
ALTER TABLE [dbo].[tblAssetCategory]  WITH CHECK ADD  CONSTRAINT [FK_tblAssetCategory_tblAssetType] FOREIGN KEY([AssetTypeId])
REFERENCES [dbo].[tblAssetType] ([AssetTypeId])
GO
ALTER TABLE [dbo].[tblAssetCategory] CHECK CONSTRAINT [FK_tblAssetCategory_tblAssetType]
GO
ALTER TABLE [dbo].[tblAssetStock]  WITH CHECK ADD  CONSTRAINT [FK_tblAssetStock_MST_Company] FOREIGN KEY([Comp_Code])
REFERENCES [dbo].[MST_Company] ([CompanyId])
GO
ALTER TABLE [dbo].[tblAssetStock] CHECK CONSTRAINT [FK_tblAssetStock_MST_Company]
GO
ALTER TABLE [dbo].[tblAssetStock]  WITH CHECK ADD  CONSTRAINT [FK_tblAssetStock_MST_Department] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[MST_Department] ([DepartmentId])
GO
ALTER TABLE [dbo].[tblAssetStock] CHECK CONSTRAINT [FK_tblAssetStock_MST_Department]
GO
ALTER TABLE [dbo].[tblAssetStock]  WITH CHECK ADD  CONSTRAINT [FK_tblAssetStock_tblAssetBrand] FOREIGN KEY([AssetBrandId])
REFERENCES [dbo].[tblAssetBrand] ([AssetBrandId])
GO
ALTER TABLE [dbo].[tblAssetStock] CHECK CONSTRAINT [FK_tblAssetStock_tblAssetBrand]
GO
ALTER TABLE [dbo].[tblAssetStock]  WITH CHECK ADD  CONSTRAINT [FK_tblAssetStock_tblAssetCategory] FOREIGN KEY([AssetCategoryId])
REFERENCES [dbo].[tblAssetCategory] ([AssetCategoryId])
GO
ALTER TABLE [dbo].[tblAssetStock] CHECK CONSTRAINT [FK_tblAssetStock_tblAssetCategory]
GO
ALTER TABLE [dbo].[tblAssetStock]  WITH CHECK ADD  CONSTRAINT [FK_tblAssetStock_tblAssetType] FOREIGN KEY([AssetTypeId])
REFERENCES [dbo].[tblAssetType] ([AssetTypeId])
GO
ALTER TABLE [dbo].[tblAssetStock] CHECK CONSTRAINT [FK_tblAssetStock_tblAssetType]
GO
ALTER TABLE [dbo].[tblAssetStockDetail]  WITH CHECK ADD  CONSTRAINT [FK_tblAssetStockDetail_tblAssetStock] FOREIGN KEY([AssetStockId])
REFERENCES [dbo].[tblAssetStock] ([AssetStockId])
GO
ALTER TABLE [dbo].[tblAssetStockDetail] CHECK CONSTRAINT [FK_tblAssetStockDetail_tblAssetStock]
GO
ALTER TABLE [dbo].[tblCallCategory]  WITH CHECK ADD  CONSTRAINT [FK__tblCallCa__CallG__2D47B39A] FOREIGN KEY([CallGroupId])
REFERENCES [dbo].[tblCallGroup] ([CallGroupId])
GO
ALTER TABLE [dbo].[tblCallCategory] CHECK CONSTRAINT [FK__tblCallCa__CallG__2D47B39A]
GO
ALTER TABLE [dbo].[tblCallTemplate]  WITH CHECK ADD  CONSTRAINT [FK__tblCallTe__CallC__5FD33367] FOREIGN KEY([CallCategoryId])
REFERENCES [dbo].[tblCallCategory] ([CallCategoryId])
GO
ALTER TABLE [dbo].[tblCallTemplate] CHECK CONSTRAINT [FK__tblCallTe__CallC__5FD33367]
GO
ALTER TABLE [dbo].[tblCallTemplate]  WITH CHECK ADD  CONSTRAINT [FK__tblCallTe__CallG__2F2FFC0C] FOREIGN KEY([CallGroupId])
REFERENCES [dbo].[tblCallGroup] ([CallGroupId])
GO
ALTER TABLE [dbo].[tblCallTemplate] CHECK CONSTRAINT [FK__tblCallTe__CallG__2F2FFC0C]
GO
ALTER TABLE [dbo].[tblProject]  WITH CHECK ADD  CONSTRAINT [FK_tblProject_MST_Company] FOREIGN KEY([CompanyName])
REFERENCES [dbo].[MST_Company] ([CompanyId])
GO
ALTER TABLE [dbo].[tblProject] CHECK CONSTRAINT [FK_tblProject_MST_Company]
GO
ALTER TABLE [dbo].[tblProject]  WITH CHECK ADD  CONSTRAINT [FK_tblProject_TeamManage] FOREIGN KEY([HandeledByTeam])
REFERENCES [dbo].[TeamManage] ([Id])
GO
ALTER TABLE [dbo].[tblProject] CHECK CONSTRAINT [FK_tblProject_TeamManage]
GO
ALTER TABLE [dbo].[tblProjectDetail]  WITH CHECK ADD  CONSTRAINT [FK_tblProjectDetail_tblProject] FOREIGN KEY([Project_FK_Id])
REFERENCES [dbo].[tblProject] ([Pm_Id])
GO
ALTER TABLE [dbo].[tblProjectDetail] CHECK CONSTRAINT [FK_tblProjectDetail_tblProject]
GO
ALTER TABLE [dbo].[tblRoleprivileges]  WITH CHECK ADD  CONSTRAINT [FK__tblRolepr__PageI__0F4D3C5F] FOREIGN KEY([PageId])
REFERENCES [dbo].[tblPageMaster] ([PageId])
GO
ALTER TABLE [dbo].[tblRoleprivileges] CHECK CONSTRAINT [FK__tblRolepr__PageI__0F4D3C5F]
GO
ALTER TABLE [dbo].[tblRoleprivileges]  WITH CHECK ADD  CONSTRAINT [FK__tblRolepr__Title__3118447E] FOREIGN KEY([TitleId])
REFERENCES [dbo].[MST_Title] ([TitleId])
GO
ALTER TABLE [dbo].[tblRoleprivileges] CHECK CONSTRAINT [FK__tblRolepr__Title__3118447E]
GO
ALTER TABLE [dbo].[tblTemplate]  WITH CHECK ADD  CONSTRAINT [FK_tblTemplate_tblTempCategory] FOREIGN KEY([TempCategory_Fk_Id])
REFERENCES [dbo].[tblTempCategory] ([TempCategoryId])
GO
ALTER TABLE [dbo].[tblTemplate] CHECK CONSTRAINT [FK_tblTemplate_tblTempCategory]
GO
ALTER TABLE [dbo].[tblUserDetail]  WITH CHECK ADD  CONSTRAINT [FK__tblUserDe__UserL__39AD8A7F] FOREIGN KEY([UserLoginId])
REFERENCES [dbo].[tblUserLogin] ([UserLoginId])
GO
ALTER TABLE [dbo].[tblUserDetail] CHECK CONSTRAINT [FK__tblUserDe__UserL__39AD8A7F]
GO
ALTER TABLE [dbo].[tblUserLogin]  WITH CHECK ADD  CONSTRAINT [FK_tblUserLogin_TeamManage] FOREIGN KEY([Team])
REFERENCES [dbo].[TeamManage] ([Id])
GO
ALTER TABLE [dbo].[tblUserLogin] CHECK CONSTRAINT [FK_tblUserLogin_TeamManage]
GO
ALTER TABLE [dbo].[tblUserprivileges]  WITH CHECK ADD  CONSTRAINT [FK__tblUserpr__PageI__0E591826] FOREIGN KEY([PageId])
REFERENCES [dbo].[tblPageMaster] ([PageId])
GO
ALTER TABLE [dbo].[tblUserprivileges] CHECK CONSTRAINT [FK__tblUserpr__PageI__0E591826]
GO
ALTER TABLE [dbo].[tblUserprivileges]  WITH CHECK ADD  CONSTRAINT [FK__tblUserpr__UserL__38B96646] FOREIGN KEY([UserLoginId])
REFERENCES [dbo].[tblUserLogin] ([UserLoginId])
GO
ALTER TABLE [dbo].[tblUserprivileges] CHECK CONSTRAINT [FK__tblUserpr__UserL__38B96646]
GO
ALTER TABLE [dbo].[TeamMapping]  WITH CHECK ADD  CONSTRAINT [FK_TeamMapping_tblUserLogin] FOREIGN KEY([Login_FK_Id])
REFERENCES [dbo].[tblUserLogin] ([UserLoginId])
GO
ALTER TABLE [dbo].[TeamMapping] CHECK CONSTRAINT [FK_TeamMapping_tblUserLogin]
GO
ALTER TABLE [dbo].[TeamMapping]  WITH CHECK ADD  CONSTRAINT [FK_TeamMapping_TeamManage] FOREIGN KEY([Team_FK_Id])
REFERENCES [dbo].[TeamManage] ([Id])
GO
ALTER TABLE [dbo].[TeamMapping] CHECK CONSTRAINT [FK_TeamMapping_TeamManage]
GO
/****** Object:  StoredProcedure [dbo].[GETALLASPNETUSERROLE]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec USP_GETPROJECTDETAIL_BYID  1 , 10
CREATE PROCEDURE [dbo].[GETALLASPNETUSERROLE]
(
--@Id bigint= null
 @currentPage int=1,
  @recordsPerPage int 
--@Search nVarchar = null

)
AS
BEGIN
	 DECLARE @ROWCOUNT INT=0;   
   
   SELECT ROW_NUMBER() over (ORDER BY Id) AS Rownumber,* 
	INTO #TEMP01  from AspNetUsers

   --SELECT  Pm_Id,Comp_Code,CompanyName,Dept_Code,Div_Code,OwnerName,Category,ProjectName,StartDate,PromiseDate,FinishDate,Percentage,[Status],
   --HandeledByTeam,DevelopedBy,CreateOn,Project_Description,CreatedBy,FollowUpBy,CallId
   --FROM 

   set @ROWCOUNT = @@ROWCOUNT
  	select @ROWCOUNT TotalCount, * from #TEMP01 
	WHERE Rownumber  BETWEEN ((@currentPage - 1) * @recordsPerPage + 1) AND (@currentPage * @recordsPerPage)
 

END
GO
/****** Object:  StoredProcedure [dbo].[GetAllProjectStatus]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllProjectStatus]



AS
BEGIN

DECLARE @Completed INT
DECLARE @InProgress INT
DECLARE @NotStarted INT 

SET @Completed = (select count(Status) as 'Completed' from [ODC_PMS_Auth].[dbo].[tblProject]
where Status = 3)

SET @InProgress = (select count(Status) as 'InProgress' from [ODC_PMS_Auth].[dbo].[tblProject]
where Status = 2)

SET @NotStarted = (select count(Status) as 'NotStarted' from [ODC_PMS_Auth].[dbo].[tblProject]
where Status = 1)

SELECT @Completed Completed ,
 @InProgress InProgress,
 @NotStarted NotStarted

END
GO
/****** Object:  StoredProcedure [dbo].[GetPieChartData1]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 Create PROCEDURE [dbo].[GetPieChartData1]
AS
BEGIN
    SELECT * FROM dbo.DummyPieChartData;
END
GO
/****** Object:  StoredProcedure [dbo].[GetProjectDetailPercentage]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProjectDetailPercentage]

--@Id BIGINT = null

AS
BEGIN

select ProjectName, Percentage from [ODC_PMS_Auth].[dbo].[tblProject]
--where Pm_Id = @Id

END
GO
/****** Object:  StoredProcedure [dbo].[GetProjectTaskStatus]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProjectTaskStatus]

@Id BIGINT = null

AS
BEGIN

DECLARE @Completed INT
DECLARE @InProgress INT
DECLARE @NotStarted INT 

SET @Completed = (select count(Status) as 'Completed' from [ODC_PMS_Auth].[dbo].[tblProject]
where Status = 3 and Pm_Id = @Id)

SET @InProgress = (select count(Status) as 'InProgress' from [ODC_PMS_Auth].[dbo].[tblProject]
where Status = 2  and Pm_Id = @Id)

SET @NotStarted = (select count(Status) as 'NotStarted' from [ODC_PMS_Auth].[dbo].[tblProject]
where Status = 1  and Pm_Id = @Id)

SELECT @Completed Completed ,
 @InProgress InProgress,
 @NotStarted NotStarted

END
GO
/****** Object:  StoredProcedure [dbo].[PatchProjectDataEditBar]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PatchProjectDataEditBar]
(
 @Pm_Id bigint
)
AS
BEGIN
   SELECT ANU.FullName as AssignedtoNAme, MC.Desc_Eng ,
   ANU1.FullName as FollowupByName,
   ANU2.FullName as RequestedByName,
   TM.Team, tp.*  from tblProject tp 
   left join MST_Company MC on tp.CompanyName = MC.CompanyId
   left join TeamManage TM on tp.HandeledByTeam = TM.Id
   left join AspNetUsers ANU on tp.AssignedTo = ANU.Id
   left join AspNetUsers ANU1 on tp.FollowUp = ANU1.Id
   left join AspNetUsers ANU2 on tp.RequestedBy = ANU2.Id
   where Pm_Id = @Pm_Id
END

GO
/****** Object:  StoredProcedure [dbo].[PatchUserDataEditBar]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[PatchUserDataEditBar]
(
 @Id uniqueidentifier
)
AS
BEGIN
   SELECT UserName,FirstName,LastName,Email,PhoneNumber,UserStatus,CreatedDate from AspNetUsers where Id = @Id
END
GO
/****** Object:  StoredProcedure [dbo].[ProcGetAllUsersList]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC [dbo].[ADMIN_PROC_GET_CUSTOMER_LIST] 1,100,NULL,NULL,NULL,NULL

CREATE PROCEDURE [dbo].[ProcGetAllUsersList]
( 
	@currentPage INT = 1,
	@recordsPerPage INT = 20,
	@Search NVARCHAR(500) = NULL ,
	@SortBy nvarchar(1000) = null
	
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ROWCOUNT BIGINT=0;

	SELECT ROW_NUMBER() OVER (ORDER BY A.CreatedDate desc) AS ROWINDEX,A.Id,convert(varchar, A.CreatedDate, 106) AS CreatedDate
	,FullName,UserName,FirstName,LastName,Email,PhoneNumber,CountryCode,UserStatus,C.Description AS RoleName,C.Description AS RoleDesciption
	INTO #tempAspNetUsers
	FROM AspNetUsers A
	LEFT OUTER JOIN AspNetUserRoles B ON A.Id=B.UserId
	INNER JOIN AspNetRoles C ON B.RoleId=C.Id
	WHERE A.UserStatus = 1 AND (
	 ((@Search IS NOT NULL AND A.FullName LIKE'%'+ @Search+'%')OR (@Search IS NULL AND 1=1)) 
	OR ((@Search IS NOT NULL AND A.Email LIKE'%'+ @Search+'%')OR (@Search IS NULL AND 1=1)) 
	OR ((@Search IS NOT NULL AND A.PhoneNumber LIKE'%'+ @Search+'%')OR (@Search IS NULL AND 1=1)) 
	)
	 

	SET @ROWCOUNT=@@ROWCOUNT;
	   SELECT @ROWCOUNT AS TotalRecords,*
	   FROM #tempAspNetUsers   
	   WHERE [ROWINDEX]  BETWEEN ((@currentPage - 1) * @recordsPerPage + 1) AND (@currentPage * @recordsPerPage)

END
GO
/****** Object:  StoredProcedure [dbo].[ProcGetDropDownList]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC [dbo].[ADMIN_PROC_GET_CUSTOMER_LIST] 1,100,NULL,NULL,NULL,NULL

CREATE PROCEDURE [dbo].[ProcGetDropDownList]
( 
	@Flag Nvarchar(128)=NULL,
	@Id Int=NULL
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 
 DECLARE @DropDown Table
 (  
     [Value] INT,  
     [Text] NVARCHAR(150)  
 )  
 -- IF(@Flag = 'FT')  
 -- BEGIN  
 -- INSERT INTO @DropDown  
 -- SELECT   Id,FounderTypeName
 -- FROM [company].[FounderType]
 -- WHERE IsActive=1
 --END
  
 IF(@Flag = 'OT')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,OperationTypeName
  FROM [company].[OperationType]
  WHERE IsActive=1
 END
 ELSE  IF(@Flag = 'Stage')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,StageName
  FROM [company].[Stage]
  WHERE IsActive=1
 END
  ELSE  IF(@Flag = 'StartUpStructured')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,StartUpStructur
  FROM [company].[StartUpStructured]
  WHERE IsActive=1
 END
 ELSE  IF(@Flag = 'Category')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,CategoryName
  FROM [company].[Category]
  WHERE IsActive=1
 END
 ELSE  IF(@Flag = 'SubCategory')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,SubCategoryName
  FROM [company].[SubCategory]
  WHERE IsActive=1 AND CategoryId=@Id
 END
  ELSE  IF(@Flag = 'CT')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,BlockChainTypeName
  FROM [Company].[BlockChainType]
  WHERE IsActive=1 
 END
  ELSE  IF(@Flag = 'country')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,name
  FROM [company].[Countries]
 END
 ELSE  IF(@Flag = 'state')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,name
  FROM [company].[States] WHERE country_id=@Id
 END
 ELSE  IF(@Flag = 'city')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,name
  FROM [company].[Cities] WHERE state_id=@Id
 END
 ELSE  IF(@Flag = 'status')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,CompanyStatus
  FROM [company].CompanyStatuses 
 END
 ELSE  IF(@Flag = 'Ilevel')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,InterestLevelName
  FROM [company].InterestLevel 
 END
 ELSE  IF(@Flag = 'UserType')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,UserType
  FROM AspNetUsersTypes WHERE Id In (4)
 END
 ELSE  IF(@Flag = 'TemplateType')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,TemplateTypeName
  FROM TemplateType WHERE IsActive=1
 END
 ELSE  IF(@Flag = 'AdminWallet')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT A.Id,WalletTypeName
  FROM Company.AdminWalletMaster A
  INNER JOIN Company.WalletTypeMaster B ON A.WalletTypeId=B.Id
  WHERE A.IsActive=1
 END
  ELSE  IF(@Flag = 'TokenCategory')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,TokenCategoryName
  FROM [Company].TokenCategory WHERE IsActive=1
 END

  ELSE  IF(@Flag = 'TokenSubCategory')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,TokenSubCategoryName
  FROM [Company].TokenSubCategory WHERE IsActive=1
 END
  ELSE  IF(@Flag = 'Network')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,NetworkName
  FROM [Company].NetworkMaster WHERE IsActive=1
 END
  ELSE  IF(@Flag = 'WalletType')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,WalletTypeName
  FROM [Company].WalletTypeMaster WHERE IsActive=1
 END
  ELSE  IF(@Flag = 'LimitedAccessType')  
 BEGIN  
  INSERT INTO @DropDown  
  SELECT   Id,LimitedAccessTypeName
  FROM [Company].LimitedAccessTypeMaster 
 END
  SELECT * FROM @DropDown 

END
GO
/****** Object:  StoredProcedure [dbo].[Search_ProjectManagement]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Search_ProjectManagement]
(
@currentPage INT = 0,
@RecordPerPage INT = 0,
@CompanyName Int = NULL,
@Category nvarchar(50) = null,
@Pm_Id BigInt = null,
@ProjectName nvarchar(255) = null,
@Description nvarchar(MAX) = null,
@RequestedBy UniqueIdentifier = null,
@FollowUpBy UniqueIdentifier = null,
@AssignTeam bigint = null,
@AssignedPerson UniqueIdentifier = null,
@StartDate datetime = null,
@Status nvarchar(255) = null

)
AS
BEGIN
SET FMTONLY OFF


    DECLARE @ROWCOUNT INT=0;
    SELECT ROW_NUMBER() over (ORDER BY Pm_Id) AS Rownumber,* 
    INTO #TEMP01 
  FROM tblProject 
    WHERE ((@CompanyName IS NOT NULL AND( CompanyName = @CompanyName)) OR (@CompanyName IS NULL AND 1=1))
    AND ((@Category IS NOT NULL AND (Category Like '%'+ @Category+'%')) OR (@Category IS NULL AND 1=1))
	 AND ((@Pm_Id IS NOT NULL AND( Pm_Id = @Pm_Id)) OR (@Pm_Id IS NULL AND 1=1))
	AND ((@ProjectName IS NOT NULL AND (ProjectName Like '%'+ @ProjectName+'%')) OR (@ProjectName IS NULL AND 1=1))
	AND ((@Description IS NOT NULL AND (Project_Description Like '%'+ @Description+'%')) OR (@Description IS NULL AND 1=1))
	 AND((@RequestedBy IS NOT NULL AND( RequestedBy = @RequestedBy)) OR (@RequestedBy IS NULL AND 1=1))
	 AND((@FollowUpBy IS NOT NULL AND( FollowUp = @FollowUpBy)) OR (@FollowUpBy IS NULL AND 1=1))
	 AND((@AssignTeam IS NOT NULL AND( HandeledByTeam = @AssignTeam)) OR (@AssignTeam IS NULL AND 1=1))
	 AND((@AssignedPerson IS NOT NULL AND( AssignedTo = @AssignedPerson)) OR (@AssignedPerson IS NULL AND 1=1))
	 AND((@StartDate IS NOT NULL AND (StartDate = @StartDate)) OR (@StartDate IS NULL AND 1=1))
    AND ((@Status IS NOT NULL AND (Status Like '%'+ @Status+'%')) OR (@Status IS NULL AND 1=1))
	

    SET @ROWCOUNT=@@ROWCOUNT

    select @ROWCOUNT TotalCount, * from #TEMP01 
    WHERE Rownumber  BETWEEN ((@currentPage - 1) * @RecordPerPage + 1) AND (@currentPage * @RecordPerPage)
End
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteMasterTable]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_DeleteMasterTable]

@Id int = null,
@TableName NVARCHAR(255) = null

AS

BEGIN
DECLARE @MSG NVARCHAR(MAX)
DECLARE @sql nvarchar(max)
BEGIN
EXEC('Delete From ' + @TableName + ' Where Id = ' +@Id)

			SET @MSG = 'NAME DELETED SUCCESSFULLY !!'
	 END
	 SELECT @MSG AS MSG
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dropdownlistforAssignedPerson]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_dropdownlistforAssignedPerson]
as
begin

select Id , FullName from [ODC_PMS_Auth].[dbo].[AspNetUsers] 
Where UserStatus = 1

End
GO
/****** Object:  StoredProcedure [dbo].[sp_dropdownlistforAssignTeam]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_dropdownlistforAssignTeam]
as
begin

select Id , Team from [ODC_PMS_Auth].[dbo].[TeamManage]

End
GO
/****** Object:  StoredProcedure [dbo].[sp_dropdownlistforcompanyname]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_dropdownlistforcompanyname]
as
begin

select CompanyId, Desc_Eng from [ODC_PMS_Auth].[dbo].[MST_Company]

End
GO
/****** Object:  StoredProcedure [dbo].[sp_dropdownlistforFollowUpBy]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_dropdownlistforFollowUpBy]
as
begin

select Id , FullName from [ODC_PMS_Auth].[dbo].[AspNetUsers]
Where UserStatus = 1
End
GO
/****** Object:  StoredProcedure [dbo].[sp_dropdownlistforprojectname]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_dropdownlistforprojectname]
as
begin

select Pm_Id, ProjectName from [ODC_PMS_Auth].[dbo].[tblProject]

End
GO
/****** Object:  StoredProcedure [dbo].[sp_dropdownlistforRequestedBy]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_dropdownlistforRequestedBy]
as
begin

select Id , FullName from [ODC_PMS_Auth].[dbo].[AspNetUsers]
Where UserStatus = 1
End
GO
/****** Object:  StoredProcedure [dbo].[sp_dropdownProjectCategory]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_dropdownProjectCategory]
as
begin
   SELECT  *  from [ODC_PMS_Auth].[dbo].[MT_ProjectCategory]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dropdownProjectStatus]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_dropdownProjectStatus]
as
begin
   SELECT  *  from [ODC_PMS_Auth].[dbo].[MT_ProjectStatus]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetMasterTable]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetMasterTable]
as
begin
 SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'MT_%'
END


--SELECT * FROM INFORMATION_SCHEMA.TABLES
--WHERE TABLE_NAME LIKE 'MT_%'


--SELECT * FROM INFORMATION_SCHEMA.TABLES
--WHERE TABLE_NAME LIKE '%CATEGORY'
GO
/****** Object:  StoredProcedure [dbo].[sp_GetMasterTableById]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetMasterTableById]
@Id int = null
as
Begin
Declare @FormName Nvarchar(500)
IF(@Id = 1)
BEGIN
Set @FormName = 'Project Category'

   SELECT  *  from [ODC_PMS_Auth].[dbo].[tblProjectCategory]
END
ELSE IF(@Id = 2)
Begin
Set @FormName = 'Project Status'

 SELECT  Id, Name from [ODC_PMS_Auth].[dbo].[tblProjectStatus]
END
Else If(@Id = 3)
Begin
Set @FormName = 'Team Manage'
 SELECT  Cast(Id as int),Team as Name,Category from [ODC_PMS_Auth].[dbo].[TeamManage]
END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetMasterTableByName]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec sp_GetMasterTableByName 'MT_ProjectStatus' , 1 , 10
CREATE PROCEDURE [dbo].[sp_GetMasterTableByName]
@Table_Name Nvarchar (50),
@currentPage int = 1,
@recordsPerPage int
as
Begin
--Declare @tablename Nvarchar(50) = 'MT_ProjectCategory'
DECLARE @ROWCOUNT INT=0;


 DECLARE @SqlQuery NVARCHAR(MAX)
    SET @SqlQuery = N'SELECT ROW_NUMBER() over (ORDER BY ID) AS Rownumber ' +' '+ ',*  FROM ' + QUOTENAME(@Table_Name) + ' GROUP BY ID,NAME'  


	declare @tmp table(
    Rownumber int,
    id int ,
    NAME Nvarchar(50)
    )
    insert into @tmp
    EXEC sp_executesql @SqlQuery
    select * into #temp01 from @tmp

    SET @ROWCOUNT=@@ROWCOUNT
	select @ROWCOUNT TotalCount,* from  #temp01
    WHERE Rownumber  BETWEEN ((@currentPage - 1) * @recordsPerPage + 1) AND (@currentPage * @recordsPerPage)

--EXEC('SELECT * FROM ' + @Table_Name)

END


GO
/****** Object:  StoredProcedure [dbo].[sp_GetMasterTableRowCount]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_GetMasterTableRowCount 'MT_ProjectStatus'
CREATE PROCEDURE [dbo].[sp_GetMasterTableRowCount]
@Table_Name NVARCHAR(50)
AS
BEGIN
    DECLARE @SqlQuery NVARCHAR(MAX)
    SET @SqlQuery = N'SELECT COUNT(*) AS ' +'''  RowCount ''' +' FROM ' + QUOTENAME(@Table_Name)
    
    EXEC sp_executesql @SqlQuery

	print @SqlQuery
END

--SELECT COUNT(*) AS 'RowCount' FROM [MT_ProjectStatus]
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertandUpdateMasterTable]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC sp_InsertandUpdateMasterTable null, 'PR' , 'MT_ProjectStatus'
CREATE PROC [dbo].[sp_InsertandUpdateMasterTable]

@Id int = null,
@FormName NVARCHAR(255) = NULL,
@TableName nvarchar(255) = null
AS
BEGIN
DECLARE @MSG NVARCHAR(MAX)
DECLARE @sql nvarchar(max)
IF(@Id > 0)
BEGIN
EXEC('UPDATE ' + @TableName + ' SET NAME = '''+ @FormName + ''' Where Id = ' +@Id)
			SET @MSG = 'NAME UPDATED SUCCESSFULLY !!'
	 END
	 IF(@Id is null)
	 BEGIN
SET @sql = 'INSERT INTO ' + @TableName + ' (NAME) VALUES (''' + CAST(@FormName AS nvarchar(max)) + ''')'
    EXEC sp_executesql @sql
			SET @MSG = 'NAME INSERTED SUCCESSFULLY !!'
	 END
SELECT @MSG AS MSG
END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertandUpdateProject]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_InsertandUpdateProject]
@Pm_Id BIGINT = null,
@Comp_Code INT = null,
@CompanyName INT ,
@Dept_Code INT = null,
@Div_Code INT = null,
@RequestedBy uniqueidentifier = null,
@Category NVARCHAR(255),
@ProjectName NVARCHAR(255),
@StartDate datetime,
@PromiseDate datetime,
@FinishDate datetime = NULL,
@Percentage float = NULL,
@Status nvarchar(255) = NULL,
@HandeledByTeam bigint= NULL,
@AssingedTo uniqueidentifier = NULL,
@CreateOn datetime= NULL ,
@Project_Description nvarchar(MAX) = Null,
@CreatedBy uniqueidentifier = NULL,
@FollowUp uniqueidentifier = NULL,
@CallId BIGINT = NULL,
@MailCC nvarchar(512) = Null,
@BenefitForCompany nvarchar(1012) = Null



AS

BEGIN
DECLARE @MSG NVARCHAR(MAX)
--	 ALTER TABLE [dbo].[tblProject]
--DROP CONSTRAINT [FK_tblProject_TeamManage];

--ALTER TABLE [dbo].[tblProject]
--DROP CONSTRAINT [FK_tblProject_MST_Company];
     IF(@Pm_Id > 0)



	 BEGIN
	      UPDATE tblProject SET 
    Comp_Code = @Comp_Code,
    CompanyName = @CompanyName,
    Dept_Code = @Dept_Code,
    Div_Code = @Div_Code,
    RequestedBy = @RequestedBy,
    Category = @Category,
    ProjectName = @ProjectName,
    StartDate = @StartDate,
    PromiseDate = @PromiseDate,
    FinishDate = @FinishDate,
    Percentage = @Percentage,
    Status = @Status,
    HandeledByTeam = @HandeledByTeam,
    AssignedTo = @AssingedTo,
    CreateOn = @CreateOn,
    Project_Description = @Project_Description,
    --AssignedPerson = @CreatedBy,
    FollowUp = @FollowUp,
    CallId = @CallId,
    MailCC = @MailCC,
    BenefitForCompany = @BenefitForCompany
				   
			WHERE Pm_Id = @Pm_Id

			SET @MSG = 'PROJECT DETAILS UPDATED SUCCESSFULLY !!'


	 END
	 ELSE
	 BEGIN
	      INSERT INTO tblProject (
    Comp_Code,
    CompanyName,
    Dept_Code,
    Div_Code,
    RequestedBy,
    Category,
    ProjectName,
    StartDate,
    PromiseDate,
    FinishDate,
    Percentage,
    Status,
    HandeledByTeam,
    AssignedTo,
    CreateOn,
    Project_Description,
    FollowUp,
    CallId,
    MailCC,
    BenefitForCompany
								) 
								 VALUES ( 
    @Comp_Code,
    @CompanyName,
    @Dept_Code,
    @Div_Code,
    @RequestedBy,
    @Category,
    @ProjectName,
    @StartDate,
    @PromiseDate,
    @FinishDate,
    @Percentage,
    @Status,
    @HandeledByTeam,
    @AssingedTo,
    @CreateOn,
    @Project_Description,
    --@CreatedBy,
    @FollowUp,
    @CallId,
    @MailCC,
    @BenefitForCompany
									)
			SET @MSG = 'PROJECT DETAILS INSERTED SUCCESSFULLY !!'
	 END
SELECT @MSG AS MSG
--			ALTER TABLE [dbo].[tblProject]  WITH CHECK ADD  CONSTRAINT [FK_tblProject_MST_Company] FOREIGN KEY([CompanyName])
--REFERENCES [dbo].[MST_Company] ([CompanyId])
--ALTER TABLE [dbo].[tblProject]  WITH CHECK ADD  CONSTRAINT [FK_tblProject_TeamManage] FOREIGN KEY([HandeledByTeam])
--REFERENCES [dbo].[TeamManage] ([Id])
END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertandUpdateProjectTaskDetails]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_InsertandUpdateProjectTaskDetails]
@Id Bigint = null,
@Project_FK_Id BIGINT = null,
@Task_Description nvarchar(MAX)=null,
@Comments nvarchar(MAX)=null,
@StartDate datetime=null,
@CompleteDate datetime=null,
@File nvarchar(MAX) = null,
@ActionBy Nvarchar(255) = null,
@Status Nvarchar(255)=null,
@CreatedBy BIGINT = null,
@ReOpenBy BIGINT = null

AS

BEGIN
DECLARE @MSG NVARCHAR(MAX)
     IF(@Id > 0)
	 BEGIN
	      UPDATE tblProjectDetail SET 
    Description = @Task_Description,
    Comment = @Comments,
    StartDate = @StartDate,
    EndDate = @CompleteDate,
    [File] = @File,
	ActionBy = @ActionBy,
	Status = @Status,
	CreatedBy = @CreatedBy,
	ReOpenBy = @ReOpenBy
   
				   
			WHERE Id = @Id

			SET @MSG = 'TASK DETAILS UPDATED SUCCESSFULLY !!'
	 END
	 ELSE
	 BEGIN
	      INSERT INTO tblProjectDetail(
    Project_FK_Id,
    Description,
    Comment,
    StartDate,
    EndDate,
    [File]					) 
								 VALUES ( 
    @Project_FK_Id,
    @Task_Description,
    @Comments,
    @StartDate,
    @CompleteDate,
    @File							)
			SET @MSG = 'TASK DETAILS INSERTED SUCCESSFULLY !!'
	 END
SELECT @MSG AS MSG
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GETPROJECTDETAIL_BYID]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GETPROJECTDETAIL_BYID]
(
--@Id bigint= null
 @currentPage int=1,
  @recordsPerPage int 
--@Search nVarchar = null

)
AS
BEGIN
	 DECLARE @ROWCOUNT INT=0;   
   
   SELECT ROW_NUMBER() over (ORDER BY Pm_Id) AS Rownumber,
   ASP1.FullName as RequestedByName,
   Asp2.FullName as AssignToName,
   Asp3.FullName as FollowUpName,
   TM.Team as TeamName,
   MTS.Name as StatusName,
   tp.* 
	INTO #TEMP01  from tblProject tp
	left join MT_ProjectStatus MTS on tp.Status = MTS.Id
	left join TeamManage TM on tp.HandeledByTeam = TM.Id
	left join AspNetUsers ASP1 on tp.RequestedBy = ASP1.Id
	left join AspNetUsers ASP2 on tp.AssignedTo = ASP2.Id
	left join AspNetUsers ASP3 on tp.FollowUp = ASP3.Id

   --SELECT  Pm_Id,Comp_Code,CompanyName,Dept_Code,Div_Code,OwnerName,Category,ProjectName,StartDate,PromiseDate,FinishDate,Percentage,[Status],
   --HandeledByTeam,DevelopedBy,CreateOn,Project_Description,CreatedBy,FollowUpBy,CallId
   --FROM 

   set @ROWCOUNT = @@ROWCOUNT
  	select @ROWCOUNT TotalCount, * from #TEMP01 
	WHERE Rownumber  BETWEEN ((@currentPage - 1) * @recordsPerPage + 1) AND (@currentPage * @recordsPerPage)
 

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GETPROJECTDETAILTABLE_LIST]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GETPROJECTDETAILTABLE_LIST]
(
@FK_ID BIGINT= null,
 @currentPage int=1,
 @recordsPerPage int
)
AS
BEGIN
 DECLARE @ROWCOUNT INT=0;   
   
   SELECT ROW_NUMBER() over (ORDER BY Id) AS Rownumber, Id,Project_FK_Id,Comment,cDatetime,ActionBy,StartDate,EndDate,[Status],AssignTo,CallGroup,CallId,ReOpen,ReopenBy,[File],CreatedOn,CreatedBy 
  , isnull(Description,'') Description INTO #TEMP01
   FROM tblProjectDetail
   WHERE Project_FK_Id=@FK_ID

    set @ROWCOUNT = @@ROWCOUNT
  	select @ROWCOUNT TotalCount, * from #TEMP01 
	WHERE Rownumber  BETWEEN ((@currentPage - 1) * @recordsPerPage + 1) AND (@currentPage * @recordsPerPage)
   

END
GO
/****** Object:  StoredProcedure [UserManagement].[PROC_GET_APPLICATION_USERS_ALLOTTED_PERMISSIONS_New]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*

EXEC [PROC_GET_APPLICATION_USERS_ALLOTTED_PERMISSIONS_New] null,15,12

*/
CREATE PROCEDURE [UserManagement].[PROC_GET_APPLICATION_USERS_ALLOTTED_PERMISSIONS_New]	
	--declare
	@Flag varchar(50)=NULL,
	@MemId uniqueidentifier = null,
	@RoleId uniqueidentifier =null
	
AS
BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.569  570 220 224     
		SET NOCOUNT ON;

	
		DECLARE @PrivilegesList TABLE (
			PageId INT NULL,
			Privilege_FK_Id INT NULL
		)

		/* ------------------------------ NEW CODE STARTED FROM HERE --------------------------------------------- */

		DECLARE @MyPermission TABLE (
			PageId INT NULL,
			Privilege_FK_Id INT NULL,
			IsParent int NULL
		)

		INSERT INTO @MyPermission
			SELECT  PPS.[NavigationMenusFkId] AS PageId,
			PPS.[PrivilegeActionsFkId] AS Privilege_FK_Id,
			CASE WHEN MM.ParentId IS NULL THEN 1 ELSE 0 END AS IsParent
		FROM [UserManagement].[UserPrivileges] PPS 
		INNER JOIN [UserManagement].[NavigationMenus] MM 
			ON PPS.[NavigationMenusFkId]= MM.Id
		WHERE [UsersFkId] = @MemId
		AND PPS.IsDeny = 0 AND PPS.IsGranted=1 AND PPS.IsActive=1 AND MM.IsActive=1	
					 

		INSERT INTO @MyPermission
			SELECT	[NavigationMenusFkId] AS PageId,
			[PrivilegeActionsFkId] AS Privilege_FK_Id,
			CASE WHEN MM.ParentId IS NULL THEN 1 ELSE 0 END AS IsParent
		FROM [UserManagement].[RolesPrivileges] RP
		INNER JOIN [UserManagement].[NavigationMenus] MM
			ON RP.[NavigationMenusFkId]= MM.Id 
		WHERE RP.[RolesFkId] = @RoleId  AND RP.IsActive=1 AND MM.IsActive=1
		--AND RP.Privilege_FK_Id=4					
							
		DELETE PER
		FROM @MyPermission PER
		INNER JOIN 
		(
			SELECT MP.PageId,MP.Privilege_FK_Id FROM @MyPermission MP
			INNER JOIN [UserManagement].[UserPrivileges] PP
				ON PP.[NavigationMenusFkId] = MP.PageId AND PP.[PrivilegeActionsFkId]=MP.Privilege_FK_Id
			WHERE PP.IsDeny=1 
			AND PP.IsGranted=0 
			AND PP.IsActive=1 		 
			AND PP.[UsersFkId] = @MemId
		) AS SUB ON SUB.PageId=PER.PageId AND SUB.Privilege_FK_Id=PER.Privilege_FK_Id

		--INSERT INTO @MyPermission
		--SELECT DISTINCT MM.ParentId AS PageId,4 AS Privilege_FK_Id, 
		--CASE WHEN MM.ParentId IS NOT  NULL THEN 1 ELSE 0 END AS IsParent
		--FROM [UserManagement].[NavigationMenus] MM 
		--INNER JOIN @MyPermission MP ON MM.Id= MP.PageId  WHERE MP.IsParent =0 AND MP.Privilege_FK_Id=4

		INSERT INTO @PrivilegesList 
		SELECT DISTINCT PageId,Privilege_FK_Id FROM @MyPermission

		SELECT DISTINCT PL.* FROM @PrivilegesList PL
		INNER JOIN @PrivilegesList PLO ON (PLO.PageId=PL.PageId AND PLO.Privilege_FK_Id=4)
	    
END
GO
/****** Object:  StoredProcedure [UserManagement].[PROC_GET_USERS_ALLOTTED_PERMISSIONS]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Niraj kumar singh>
-- Create date: <Create Date,,18-11-2022>
-- Description:	<Description,,>

CREATE PROCEDURE [UserManagement].[PROC_GET_USERS_ALLOTTED_PERMISSIONS]	
	--declare
	@MemId UNIQUEIDENTIFIER = null,
	@RoleId UNIQUEIDENTIFIER =null
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.569  570 220 224     
	SET NOCOUNT ON;

	IF(@RoleId!='00000000-0000-0000-0000-000000000000')
	BEGIN

	       IF OBJECT_ID('tempdb..#UserPrivilegesList') IS NOT NULL DROP TABLE #UserPrivilegesList
			
					CREATE TABLE #UserPrivilegesList ( PageId INT NULL,
												   PrivilegeId INT NULL);			
			
			IF OBJECT_ID('tempdb..#UserMyPermission') IS NOT NULL DROP TABLE #UserMyPermission
			
					CREATE TABLE #UserMyPermission ( PageId INT NULL,
												 Privilege_FK_Id INT NULL,
												 IsParent int NULL);	 
	
			--DECLARE @PrivilegesList TABLE (
			--PageId INT NULL,
			--Privilege_FK_Id INT NULL
			--)

			-- /* ------------------------------ NEW CODE STARTED FROM HERE --------------------------------------------- */

			--DECLARE @MyPermission TABLE (
			--PageId INT NULL,
			--Privilege_FK_Id INT NULL,
			--IsParent int NULL
			--)

			      INSERT INTO #UserMyPermission
				 --SELECT	PP.Page_FK_Id AS PageId,
					--	PP.Privilege_FK_Id AS Privilege_FK_Id,
					--	PP.IsParent 
					--	FROM 
					--	(
					SELECT PPS.[NavigationMenusFkId] AS PageId,PPS.[PrivilegeActionsFkId] AS Privilege_FK_Id,
					CASE WHEN MM.ParentId IS NULL THEN 1 ELSE 0 END AS IsParent
					FROM [UserManagement].[UserPrivileges] PPS INNER JOIN [UserManagement].[NavigationMenus] MM ON PPS.[NavigationMenusFkId]= MM.Id  WHERE [UsersFkId] = @MemId
					AND PPS.IsDeny = 0 AND PPS.IsGranted=1 AND PPS.IsActive=1 AND MM.IsActive=1	
					--AND PPS.Privilege_FK_Id=4				
					--) PP 

					

			         INSERT INTO #UserMyPermission
			         SELECT [NavigationMenusFkId] AS PageId,[PrivilegeActionsFkId] AS Privilege_FK_Id,
					 CASE WHEN MM.ParentId IS NULL THEN 1 ELSE 0 END AS IsParent
					 FROM [UserManagement].[RolesPrivileges] RP INNER JOIN [UserManagement].[NavigationMenus] MM ON RP.[NavigationMenusFkId]= MM.Id 
					 WHERE RP.[RolesFkId] = @RoleId  AND RP.IsActive=1 AND MM.IsActive=1
					 --AND RP.Privilege_FK_Id=4					
				
							
         
		  /*Comment for not getting records from role previlege*/
		  
     --     DELETE FROM @MyPermission where PageId IN (
		   --select distinct MP.PageId FROM @MyPermission MP
		   --INNER JOIN  [UserManagement].[UserPrivileges] PP ON PP.UMNavigationMenusFkId = MP.PageId  
		   --AND PP.UMPrivilegeActionsFkId=MP.Privilege_FK_Id
		   --where PP.IsDeny=1 
		   --AND PP.IsGranted=0 
		   --AND PP.IsActive=1 
		 
		   --AND PP.[AspNetUsersFkId] = @MemId
		   --)
		  
		 
		   /*End comment for not getting records from role previlege*/
			

			DELETE PER
			FROM #UserMyPermission PER
			INNER JOIN 
		   (
		   select MP.PageId,MP.Privilege_FK_Id FROM #UserMyPermission MP
		   INNER JOIN [UserManagement].[UserPrivileges] PP ON PP.[NavigationMenusFkId] = MP.PageId    AND PP.[PrivilegeActionsFkId]=MP.Privilege_FK_Id
		   where PP.IsDeny=1 
		   AND PP.IsGranted=0 
		   AND PP.IsActive=1 		 
		   AND PP.[UsersFkId] = @MemId
		   ) AS SUB ON SUB.PageId=PER.PageId AND SUB.Privilege_FK_Id=PER.Privilege_FK_Id


		  

		   INSERT INTO #UserMyPermission
		   SELECT DISTINCT MM.ParentId AS PageId,4 AS Privilege_FK_Id, 
		   CASE WHEN MM.ParentId IS NOT  NULL THEN 1 ELSE 0 END AS IsParent
		   FROM [UserManagement].[NavigationMenus] MM 
		   INNER JOIN #UserMyPermission MP ON MM.Id= MP.PageId  WHERE MP.IsParent =0 AND MP.Privilege_FK_Id=4

		  

		   INSERT INTO #UserPrivilegesList 
		   SELECT DISTINCT PageId,Privilege_FK_Id FROM #UserMyPermission

		
		   	SELECT DISTINCT PL.* FROM #UserPrivilegesList PL
			INNER JOIN #UserPrivilegesList PLO ON (PLO.PageId=PL.PageId AND PLO.PrivilegeId=4)



		   IF OBJECT_ID('tempdb..#UserPrivilegesList') IS NOT NULL DROP TABLE #UserPrivilegesList
		   IF OBJECT_ID('tempdb..#UserMyPermission') IS NOT NULL DROP TABLE #UserMyPermission



		   /* ------------------------------ NEW CODE ENDED HERE --------------------------------------------- */

	   END


					
				  
				    
END
GO
/****** Object:  StoredProcedure [UserManagement].[ProcAdminGetLeftSideMenu]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--EXEC [UserManagement].[ProcAdminGetLeftSideMenu] 1,'978AC6E8-CC12-42A0-0928-08DB65AADD90'
CREATE PROCEDURE [UserManagement].[ProcAdminGetLeftSideMenu]
--declare
@IsAdministrativeUser BIT,
@MemberId uniqueidentifier

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @RoleId uniqueidentifier ;
	SELECT @RoleId = RoleId FROM  [dbo].[AspNetUserRoles] WHERE UserId = @MemberId
	
	---------------------------------------Added  for parent id-------------------------------------------------------
											    DECLARE @PageTable TABLE(
												  ID BIGINT NULL
												)
												DECLARE @PARENTID TABLE(
													PARENTID BIGINT NULL												
												)												

												INSERT INTO @PageTable 
												SELECT DISTINCT NavigationMenusFkId FROM [UserManagement].[UserPrivileges] PP 
											    WHERE 
												PP.PrivilegeActionsFkId = 4 
												AND PP.IsGranted = 1 
												AND UsersFkId =	@MemberId;
												
												INSERT INTO @PARENTID
												SELECT DISTINCT ParentId FROM [UserManagement].[NavigationMenus]
												WHERE Id IN (				
												SELECT Id FROM @PageTable										
												);
											
												INSERT INTO @PARENTID
												SELECT * FROM @PageTable 


-------------------------------------------End-----------------------------------------------------




;WITH CTE AS(
			SELECT 
			MM.Id,
			MM.[MenuName],
			MM.[MenuIcon],
			MM.MenuUrl,
			MM.ParentId,
			MM.SortOrder
			FROM [UserManagement].[NavigationMenus]  MM
				WHERE MM.IsActive =1 

						AND ( MM.Id IN (SELECT ParentId FROM @PARENTID)
							  OR MM.Id IN (SELECT NavigationMenusFkId FROM [UserManagement].[RolesPrivileges] RP
												  WHERE
												  RP.PrivilegeActionsFkId = 4	
												  AND 
												  RP.RolesFkId = @RoleId
							  )
							  OR  @IsAdministrativeUser =1)


	) ,
	CTE_TILL_3RD_DEPTH AS 
	(

	SELECT 
			CT.Id,
			CT.[MenuName],
			CT.[MenuIcon],
			CT.[MenuUrl],
			CT.ParentId,
			CT.SortOrder
	FROM CTE CT
	--UNION
	--SELECT 
	--		MM.Id,
	--		MM.[MenuName],
	--		MM.[MenuIcon],
	--		MM.[MenuLink],
	--		MM.ParentId,
	--		MM.SortOrder
	--		FROM [UserManagement].[NavigationMenus]  MM
	--		INNER JOIN CTE ON CTE.Id= MM.ParentId
	--        WHERE MM.IsActive =1 -- MM.LinkDepth=3
			
	)

	
					  SELECT '[' + STUFF((
							SELECT 
								',{"Id":' + CAST(t1.Id as varchar(max))
								+ ',"ParentId":0'
								+ ',"MenuName":"' + ISNULL(t1.[MenuName],'') +'"'
								+ ',"MenuIcon":"' + ISNULL(t1.[MenuIcon],'') +'"'
								+ ',"MenuLink":"' + ISNULL(t1.[MenuUrl],'') +'"'  
								+ ',"SubMenus":' + 							
														  ISNULL((SELECT '[' + STUFF((
																SELECT 
																	',{"Id":' + CAST(t2.Id AS VARCHAR(MAX))
																	+ ',"ParentId":'+ CAST(t1.Id AS VARCHAR(MAX))
																	+ ',"MenuName":"' + ISNULL(t2.[MenuName],'') +'"'
																	+ ',"MenuIcon":"' + ISNULL(t2.[MenuIcon],'') +'"'
																	+ ',"MenuLink":"' + ISNULL(t2.[MenuUrl],'') +'"'  
																	+ ',"Loader":false'  
																	+ ',"SubMenus":' + 							
																							 ISNULL((SELECT '[' + STUFF((
																									SELECT 
																										',{"Id":' + CAST(t3.Id AS VARCHAR(MAX))
																										+ ',"ParentId":'+ CAST(t2.Id AS VARCHAR(MAX))
																										+ ',"MenuName":"' + ISNULL(t3.[MenuName],'') +'"'
																										+ ',"MenuIcon":"' + ISNULL(t3.[MenuIcon],'') +'"'
																										+ ',"MenuLink":"' + ISNULL(t3.[MenuUrl],'') +'"'  
																										+ ',"Loader":false'  
																										+'}'
																									FROM [CTE_TILL_3RD_DEPTH] t3
																									WHERE  t3.ParentId = t2.Id AND t3.ParentId IS NOT NULL																										   
																									ORDER BY t3.SortOrder
																									FOR XML PATH(''), TYPE
																							  ).value('.', 'NVARCHAR(MAX)'), 1, 1, '') + ']'),'""')
																	+'}'

																FROM [CTE_TILL_3RD_DEPTH] t2
																WHERE  t2.ParentId = t1.Id AND t2.ParentId IS NOT NULL																	 
																ORDER BY t2.SortOrder
																FOR XML PATH(''), TYPE
														  ).value('.', 'NVARCHAR(MAX)'), 1, 1, '') + ']'),'""')
								+'}'

							FROM [CTE_TILL_3RD_DEPTH] t1 
							WHERE t1.ParentId IS NULL  
							ORDER BY t1.SortOrder
							FOR XML PATH(''), TYPE
						).value('.', 'NVARCHAR(MAX)'), 1, 1, '') + ']' AS Menutree ;

END








GO
/****** Object:  StoredProcedure [UserManagement].[uspDeleteRolePrivileges]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- =============================================
-- Author:		<Anil Ghildiyal>
-- Create date: <03:25 PM 28/May/2018>
-- Description:	<Description,,SProc saves privileges for selected role.>
-- Exec [UserManagement].[uspDeleteUmRolePrivileges]  2
-- =============================================
CREATE PROCEDURE [UserManagement].[uspDeleteRolePrivileges]
	-- Add the parameters for the stored procedure here
	@RoleId UNIQUEIDENTIFIER = NULL
	
AS
BEGIN	

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	DECLARE @ReturnResult VARCHAR(512) = '', @ReturnStatus INT = 0;

		DELETE FROM UserManagement.RolesPrivileges 
	    WHERE RolesFkId = @RoleId;
		
		SET @ReturnResult = 'PermissionsRemoved';		
	    SET @ReturnStatus = 1;

	SELECT @ReturnResult AS Result, @ReturnStatus AS ResultStatus;
END







GO
/****** Object:  StoredProcedure [UserManagement].[uspGetPrivilegesByRole]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anil Ghildiyal>
-- Create date: <01:35 PM 28/May/2018>
-- Description:	<Description,,SProc returns assigned privileges to selected role.>
-- Exec [UserManagement].[uspGetPrivilegesByRole] NULL
-- =============================================
CREATE PROCEDURE [UserManagement].[uspGetPrivilegesByRole](
	-- Add the parameters for the Designation
		@RoleId UNIQUEIDENTIFIER = NULL
	)
AS
BEGIN
		DECLARE @Privileges TABLE (
		[PageId] [int] NOT NULL,
		[MenuName] [varchar](128) NULL,
		[PrivilegesId] [int] NOT NULL,
		[Privileges] [varchar](128) NULL ,
		[IsParent] [int] NOT NULL,
		[ParentId] [int] NOT NULL,
		[SortOrder] [varchar](64) NOT NULL,
		[Type] [tinyint] null

		);

		INSERT INTO @Privileges
		SELECT 
			 MPG.Id,
			 MPG.MenuName AS Pages,MPR.Id,MPR.Privilege,
			 CASE WHEN MPG.ParentId IS NULL THEN 1 ELSE 2 END IsParent,
			 CASE WHEN MPG.ParentId IS NULL THEN MPG.Id ELSE MPG.ParentId END ParentId,
			 MPG.[SortOrder],
			 MPG.[Type]
		FROM UserManagement.NavigationMenus MPG,UserManagement.PrivilegeActions  MPR 
		WHERE MPR.IsActive=1 AND MPG.IsActive=1 
		AND (@RoleId IS NOT NULL AND @RoleId='c1f34113-c145-4678-ebb6-08d7f1a4cdcb' AND MPG.Id IN (38)  /***38 Dr.Oversight FOR REVIEWER*****/
		     OR
			 @RoleId IS NOT NULL AND  @RoleId !='c1f34113-c145-4678-ebb6-08d7f1a4cdcb' AND MPG.Id  NOT IN (38)
			 OR 
			 @RoleId IS  NULL AND 1=1
			 )
		ORDER BY MPG.Id;

		
		SELECT
			PR.PageId
			,PR.PrivilegesId,
			(CASE WHEN PrivilegeActionsFkId IS NULL THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsSelected,			 
			PR.MenuName ,PR.Privileges, 
			PR.IsParent , PR.ParentId,COUNT(CH.ParentId) AS ChildCount,
			PR.[SortOrder],
			 PR.[Type]
		FROM @Privileges PR
		LEFT OUTER JOIN UserManagement.RolesPrivileges  RP ON 
					(PR.PageId = RP.NavigationMenusFkId AND PR.PrivilegesId = RP.PrivilegeActionsFkId AND RP.RolesFkId =@RoleId 					
					)
		LEFT OUTER JOIN (SELECT DISTINCT ParentId FROM @Privileges WHERE IsParent = 2) CH ON PR.PageId=CH.ParentId
			GROUP BY PR.PageId,PR.PrivilegesId,
			(CASE WHEN PrivilegeActionsFkId IS NULL THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END),			  
			PR.MenuName ,PR.Privileges, 
			PR.IsParent , PR.ParentId,PR.[SortOrder],
			 PR.[Type]
		ORDER BY PR.[SortOrder];
		
END
GO
/****** Object:  StoredProcedure [UserManagement].[uspGetPrivilegesByRole_V1]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anil Ghildiyal>
-- Create date: <01:35 PM 28/May/2018>
-- Description:	<Description,,SProc returns assigned privileges to selected role.>
-- Exec [UserManagement].[uspGetPrivilegesByRole] NULL
-- =============================================
CREATE PROCEDURE [UserManagement].[uspGetPrivilegesByRole_V1](
	-- Add the parameters for the Designation
		@RoleId UNIQUEIDENTIFIER = NULL
	)
AS
BEGIN
		DECLARE @Privileges TABLE (
		[PageId] [int] NOT NULL,
		[MenuName] [varchar](128) NULL,
		[PrivilegesId] [int] NOT NULL,
		[Privileges] [varchar](128) NULL ,
		[IsParent] [int] NOT NULL,
		[ParentId] [int] NOT NULL,
		[SortOrder] [varchar](64) NOT NULL,
		[Type] [tinyint] null

		);

		 IF (OBJECT_ID('tempdb..#tempRoleMenu')) IS NOT NULL
                                  DROP TABLE #tempRoleMenu

		INSERT INTO @Privileges
		SELECT 
			 MPG.Id,
			 MPG.MenuName AS Pages,MPR.Id,MPR.Privilege,
			 CASE WHEN MPG.ParentId IS NULL THEN 1 ELSE 2 END IsParent,
			 CASE WHEN MPG.ParentId IS NULL THEN MPG.Id ELSE MPG.ParentId END ParentId,
			 MPG.[SortOrder],
			 MPG.[Type]
		FROM UserManagement.NavigationMenus MPG,UserManagement.PrivilegeActions  MPR 
		WHERE MPR.IsActive=1 AND MPG.IsActive=1 
		AND (@RoleId IS NOT NULL AND @RoleId='c1f34113-c145-4678-ebb6-08d7f1a4cdcb' AND MPG.Id IN (38)  /***38 Dr.Oversight FOR REVIEWER*****/
		     OR
			 @RoleId IS NOT NULL AND  @RoleId !='c1f34113-c145-4678-ebb6-08d7f1a4cdcb' AND MPG.Id  NOT IN (38)
			 OR 
			 @RoleId IS  NULL AND 1=1
			 )
		ORDER BY MPG.Id;

		
		SELECT
			PR.PageId
			,PR.PrivilegesId,
			(CASE WHEN PrivilegeActionsFkId IS NULL THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsSelected,			 
			PR.MenuName ,PR.Privileges, 
			PR.IsParent , PR.ParentId,COUNT(CH.ParentId) AS ChildCount,
			PR.[SortOrder],
			 PR.[Type]

		INTO #tempRoleMenu	
		FROM @Privileges PR
		LEFT OUTER JOIN UserManagement.RolesPrivileges  RP ON 
					(PR.PageId = RP.NavigationMenusFkId AND PR.PrivilegesId = RP.PrivilegeActionsFkId AND RP.RolesFkId =@RoleId 					
					)
		LEFT OUTER JOIN (SELECT DISTINCT ParentId FROM @Privileges WHERE IsParent = 2) CH ON PR.PageId=CH.ParentId
			GROUP BY PR.PageId,PR.PrivilegesId,
			(CASE WHEN PrivilegeActionsFkId IS NULL THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END),			  
			PR.MenuName ,PR.Privileges, 
			PR.IsParent , PR.ParentId,PR.[SortOrder],
			 PR.[Type]
		ORDER BY PR.[SortOrder];



		SELECT
			PR.PageId
			,PR.PrivilegesId,
			CAST((CASE  WHEN (IsParent=1 AND CTN>1 ) THEN 0 ELSE   PR.IsSelected	END										
			) AS BIT) AS IsSelected,
			PR.MenuName,
			PR.Privileges, 
			PR.IsParent,
			PR.ParentId,
			ChildCount,
			PR.[SortOrder],
			PR.[Type]

		FROM #tempRoleMenu	PR


		LEFT OUTER JOIN (
			select ParentId ,PrivilegesId ,COUNT(1) AS CTN											
			FROM 
			(
				SELECT ParentId,PrivilegesId,IsSelected											
				from #tempRoleMenu where IsParent=2 
			Group by ParentId,PrivilegesId,IsSelected
			) as vv 
				group by ParentId,PrivilegesId
			) AS  LT ON LT.ParentId=PR.ParentId AND LT.PrivilegesId=PR.PrivilegesId
			ORDER BY PR.SortOrder ,PR.PrivilegesId --,RT.IsParent,RT.PrivilegeId 		


END
GO
/****** Object:  StoredProcedure [UserManagement].[uspGetUserPrivileges]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Anil Ghildiyal>
-- Create date: <07:59 PM 31/May/2018>
-- Description:	<Description,,SProc returns user's privileges .>
-- Exec [UserManagement].[uspGetUserPrivileges] 'GetPrivilegesByApplicationUsers'
-- =============================================
CREATE PROCEDURE [UserManagement].[uspGetUserPrivileges]

	@UserId UNIQUEIDENTIFIER = NULL,
	@RoleId UNIQUEIDENTIFIER = NULL,
	@Flag  NVARCHAR(MAX)= NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ACTUAL_ROLE_ID UNIQUEIDENTIFIER=NULL;
	

								 IF (OBJECT_ID('tempdb..#tempMenu')) IS NOT NULL
                                  DROP TABLE #tempMenu
				          

							 DECLARE @Privileges TABLE (
									 ID INT IDENTITY,
									 UMNavigationMenusFkId INT,
									 PrivilageId INT,
									 IsSelected BIT									 
									 )

								 DECLARE @UserAssignedPermissions TABLE(
									 ID INT IDENTITY,
									 UMNavigationMenusFkId INT,
									 PrivilegeId INT,
									 IsSelected BIT
					 				 )

								 --DECLARE  @RoleId INT =-1, @RoleName NVARCHAR(128)='';
								 
								 DECLARE  @RoleName NVARCHAR(128)='';
								 
								 
										
								 SELECT TOP 1 @ACTUAL_ROLE_ID = ANUR.RoleId,@RoleName=RLS.Name 
										 FROM  dbo.AspNetUsers PR
										 LEFT OUTER JOIN dbo.AspNetUserRoles ANUR ON ANUR.UserId = PR.Id
										 LEFT OUTER JOIN  dbo.AspNetRoles RLS ON ANUR.RoleId = RLS.Id
										 WHERE PR.Id= @UserId		 
										 
					 			IF(@RoleId = NULL)
					 			BEGIN
										
										SET  @RoleId = @ACTUAL_ROLE_ID;
							    END								
								

					 		
					 		 --SELECT @UserId
								 ;WITH CTE_Permissions AS
								 (
									SELECT MPG.Id AS UMNavigationMenusFkId,MPR.Id AS PrivegesId
 									FROM UserManagement.NavigationMenus MPG,[UserManagement].PrivilegeActions  MPR 
									WHERE MPR.IsActive=1 AND MPG.IsActive=1
										 
								 ) 
		 
					 			 INSERT INTO @UserAssignedPermissions
									SELECT 
									PR.UMNavigationMenusFkId,
										   PR.PrivegesId,
										   (CASE WHEN RP.NavigationMenusFkId IS NULL THEN 0 ELSE 1 END) AS IsSelected
									FROM  CTE_Permissions PR
									LEFT OUTER JOIN UserManagement.RolesPrivileges RP 
									ON (PR.UMNavigationMenusFkId=RP.NavigationMenusFkId 
									AND PR.PrivegesId = RP.PrivilegeActionsFkId
									AND RP.RolesFkId = @RoleId									
									)
									
									--select * from @UserAssignedPermissions
															
									;WITH CTE_PAGES AS(
									
											   SELECT UAP.UMNavigationMenusFkId,UAP.PrivilegeId, 
													(CASE WHEN 
														((RP.IsGranted = 1 OR UAP.IsSelected=1) 
														AND (ISNULL(RP.IsDeny,0) != 1)
														)
														THEN 
														CAST(1 AS BIT) ELSE CAST(0 AS BIT) 
													 END)
													AS IsSelected , 
													CASE
														WHEN RP.Id IS NULL THEN 0
														WHEN RP.IsGranted = 1 THEN 1
														WHEN RP.IsDeny = 1 THEN 2
														ELSE 0
													END AS IsCustom,
													MP.MenuName as MenuName,
													MPR.Privilege,
													MP.SortOrder,													
													(CASE WHEN MP.ParentId IS NULL THEN 1 ELSE 2 END) AS IsParent, --(CASE WHEN MP.ParentId IS NULL THEN 1 ELSE 2 END) IsParent,
													(CASE WHEN MP.ParentId IS NULL THEN MP.Id ELSE MP.ParentId END) ParentId,
													@RoleName AS RoleName
													FROM @UserAssignedPermissions UAP
													
													LEFT OUTER JOIN 
													(
													SELECT * FROM UserManagement.UserPrivileges WHERE
															UsersFkId = CASE  
																	WHEN @RoleId = @ACTUAL_ROLE_ID  THEN @UserId
																	ELSE NULL END
													) RP ON 
													
													(UAP.UMNavigationMenusFkId = RP.NavigationMenusFkId AND UAP.PrivilegeId = RP.PrivilegeActionsFkId 
													AND RP.UsersFkId = @UserId)
													
													INNER JOIN (SELECT [Id],[MenuName],[ParentId],[IsActive],SortOrder  FROM UserManagement.NavigationMenus) MP ON  MP.[Id]=UAP.UMNavigationMenusFkId
													INNER JOIN UserManagement.PrivilegeActions MPR ON MPR.Id = UAP.PrivilegeId			
										)
											
										
											SELECT --RT.*,
									--	RT.IsSelected,
										--RT.[SiteId],
										CAST((CASE  WHEN (@RoleId IS NULL ) THEN 1 ELSE RT.IsSelected END) AS BIT) AS IsSelected,
										IsCustom,
										RT.IsParent,
										RT.MenuName,
										RT.UMNavigationMenusFkId AS PageId,
										RT.ParentId,
										ISNULL(RT.PrivilegeId,0) AS PrivilegesId,
										@RoleId AS RoleId,
										RT.RoleName,
										RT.Privilege AS Privileges,
										RT.SortOrder,
										COUNT(distinct CH.ParentId) AS ChildCount
										--,COUNT(TH.ParentId) AS ThirdDepthChildCount	
										into #tempMenu									
										FROM CTE_PAGES RT
										LEFT OUTER JOIN (SELECT DISTINCT ParentId FROM CTE_PAGES WHERE IsParent = 2) CH ON RT.UMNavigationMenusFkId=CH.ParentId
										--LEFT OUTER JOIN (SELECT DISTINCT ParentId FROM CTE_PAGES WHERE IsParent = 3) TH ON RT.UMNavigationMenusFkId=TH.ParentId
										--WHERE RT.ParentId=9
										GROUP BY  RT.SortOrder, RT.ParentId,RT.UMNavigationMenusFkId,RT.PrivilegeId ,RT.IsSelected,RT.MenuName,RT.IsParent,RT.Privilege,RT.RoleName,IsCustom 
										ORDER BY RT.SortOrder --,RT.IsParent,RT.PrivilegeId 
										
											
											
										
										select 
										CAST((CASE  WHEN (@RoleId IS NULL ) THEN 1 ELSE 
										CASE  WHEN (IsParent=1 AND CTN>1 ) THEN 0 ELSE 										
										  RT.IsSelected 
										END	
										END										
										) AS BIT) AS IsSelected,
										IsCustom,
										RT.IsParent,
										RT.MenuName,
										RT.PageId,
										RT.ParentId,
										RT.PrivilegesId,
										RoleId,
										RT.RoleName,
										Privileges,										
										ChildCount ,
										SortOrder
										

										from #tempMenu RT 
										LEFT OUTER JOIN (
											select ParentId ,PrivilegesId ,COUNT(1) AS CTN											
											FROM 
											(
											SELECT ParentId,PrivilegesId,IsSelected											
											from #tempMenu where IsParent=2 
											Group by ParentId,PrivilegesId,IsSelected
											) as vv 
											 group by ParentId,PrivilegesId
											) AS  LT ON LT.ParentId=RT.ParentId AND LT.PrivilegesId=RT.PrivilegesId
										   ORDER BY RT.PageId, RT.SortOrder,RT.PrivilegesId 	--,RT.IsParent,RT.PrivilegeId 		
																			
									--	SELECT --RT.*,
									----	RT.IsSelected,
									--	--RT.[SiteId],
									--	CAST((CASE  WHEN (@RoleId IS NULL ) THEN 1 ELSE RT.IsSelected END) AS BIT) AS IsSelected,
									--	RT.IsParent,
									--	RT.MenuName,
									--	RT.PageId,
									--	RT.ParentId,
									--	PrivilegesId,
									--	RoleId,
									--	RT.RoleName,
									--	Privileges
																			
									--	FROM CTE_FINAL_PAGES RT
									--	LEFT OUTER JOIN (SELECT DISTINCT ParentId FROM CTE_PAGES WHERE IsParent = 2) CH ON RT.PageId=CH.ParentId
									
										
							


END










GO
/****** Object:  StoredProcedure [UserManagement].[uspResetCustomUsersPrivileges]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anil Ghildiyal>
-- Create date: <07:28 PM 31/May/2018>
-- Description:	<Description,,SProc returns user's privileges.>
-- Exec [dbo].[uspSetUmUsersPrivileges]
-- =============================================
create PROCEDURE [UserManagement].[uspResetCustomUsersPrivileges]
@UserId UNIQUEIDENTIFIER=NULL
AS
BEGIN
	DECLARE @ReturnResult VARCHAR(512) = '', @ReturnStatus INT = 0;
	
	
	
		 BEGIN TRANSACTION trans
		 BEGIN TRY
				/*--------------------------------------------------------------*/
				/* Delete all alloted privilege to this member...*/
				DELETE FROM UserManagement.UserPrivileges WHERE UsersFkId = @UserId;
						
				IF @@TRANCOUNT > 0
					BEGIN COMMIT TRANSACTION trans;

					SET @ReturnResult = 'PermissionsGranted';
				    SET @ReturnStatus = 1;
				END
		 END TRY
	 	 BEGIN CATCH
				SELECT 0
				  --SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
				IF @@TRANCOUNT > 0
					BEGIN ROLLBACK TRANSACTION trans ;
					SET @ReturnResult = 'PermissionsFailed';
					SET @ReturnStatus = 0;
				END
		 END CATCH 
		
	SELECT @ReturnResult AS Result, @ReturnStatus AS ResultStatus;
		

		
END

  






GO
/****** Object:  StoredProcedure [UserManagement].[uspSetRolePrivileges]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Anil Ghildiyal>
-- Create date: <03:12 PM 28/May/2018>
-- Description:	<Description,,SProc saves privileges for selected role.>
-- Exec [UserManagement].[uspSetRolePrivileges] '1-1,1-2,1-3,1-4,1-5,2-1,2-2,2-3,2-4,2-5,3-1,3-2,3-3,3-4,3-5,4-1,4-2,4-3,4-4,4-5', 'db14bef5-2f8f-4d23-2fd3-08d74e2f0b56'
-- =============================================
CREATE PROCEDURE [UserManagement].[uspSetRolePrivileges]
(
	@PrivilagesString NVARCHAR(MAX)= NULL,
	@RoleId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @ReturnResult VARCHAR(512) = '', @ReturnStatus INT = 0;

	

			 BEGIN TRANSACTION trans
			 BEGIN TRY
		      
					/*--------------------------------------------------------------*/
					--FIND DESIGNATION ID FOR THIS USER..
				  
					DELETE FROM UserManagement.RolesPrivileges WHERE RolesFkId = @RoleId 
				
				
					IF(@PrivilagesString != '') 
					BEGIN
						DECLARE @tmp TAble(
						Id Int Identity ,
						PageId tinyint,
						PrivegesId tinyint,
						RoleId UNIQUEIDENTIFIER					
						);
					
						;WITH CTE AS(
							SELECT SpOuter.Items
							FROM [dbo].[udfTableValuedSplit](@PrivilagesString,',') SpOuter
						)					
					
						INSERT INTO @tmp(PageId,PrivegesId,RoleId)
						SELECT 	
							SUBSTRING(CTE.Items,1,(CHARINDEX('-', CTE.Items)-1)),
							SUBSTRING(CTE.Items,(CHARINDEX('-', CTE.Items)+1),LEN(CTE.Items)),
							@RoleId 
						FROM CTE;


						
						 /* Deny Permissions.......*/				
						INSERT INTO UserManagement.RolesPrivileges(RolesFkId,NavigationMenusFkId,PrivilegeActionsFkId,IsActive,CreatedDate) 
						SELECT RoleId,PageId,PrivegesId,1,GETUTCDATE() FROM @tmp					
										
					END
				
					/*------------------------------------------------------------------------------*/
					IF @@TRANCOUNT > 0
						BEGIN 
							COMMIT TRANSACTION trans;
							SET @ReturnResult = 'PermissionsGranted';
							SET @ReturnStatus = 1;
						END
		END TRY
		BEGIN CATCH
				print 'Error Occured'
				IF @@TRANCOUNT > 0
					BEGIN 
							ROLLBACK TRANSACTION trans;
							SET @ReturnResult = 'PermissionsFailed';
							SET @ReturnStatus = -1;
				END
		END CATCH 
	
	SELECT @ReturnResult AS ReturnResult, @ReturnStatus AS ReturnStatus;
END







GO
/****** Object:  StoredProcedure [UserManagement].[uspSetUsersPrivileges]    Script Date: 01-11-2023 16:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anil Ghildiyal>
-- Create date: <07:28 PM 31/May/2018>
-- Description:	<Description,,SProc returns user's privileges.>
-- Exec [dbo].[uspSetUmUsersPrivileges]
-- =============================================
CREATE PROCEDURE [UserManagement].[uspSetUsersPrivileges]

@PrivilagesString NVARCHAR(MAX)= NULL,
@UserId UNIQUEIDENTIFIER=NULL,
@RoleId UNIQUEIDENTIFIER = NULL


AS
BEGIN
	DECLARE @ReturnResult VARCHAR(512) = '', @ReturnStatus INT = 0 ,@ProviderRoles UNIQUEIDENTIFIER = NULL,@AdminClinicRole  UNIQUEIDENTIFIER = NULL;
	
	
	
		 BEGIN TRANSACTION trans
		 BEGIN TRY
				/*--------------------------------------------------------------*/
				/* Delete all alloted privilege to this member...*/
				DELETE FROM UserManagement.UserPrivileges WHERE UsersFkId = @UserId

				UPDATE AspNetUserRoles SET RoleId=@RoleId WHERE UserId=@UserId

				/* If people privileges are assigned All or Few Privileges are granted.*/
				IF(LEN(@PrivilagesString) > 0 AND @PrivilagesString IS NOT NULL) 
				BEGIN 
						DECLARE @tmp TABLE(
						Id Int Identity ,
						PageId Int,
						PrivegesId Int,
						RoleId UNIQUEIDENTIFIER 
						)						  

						;WITH CTE AS(
						SELECT SpOuter.Items
						FROM [dbo].[udfTableValuedSplit](@PrivilagesString,',') SpOuter
						)
						 
						Insert Into @tmp(PageId,PrivegesId,RoleId)
						SELECT  
							SUBSTRING(CTE.Items,1,(CHARINDEX('-', CTE.Items)-1)),
							SUBSTRING(CTE.Items,(CHARINDEX('-', CTE.Items)+1),LEN(CTE.Items)),
							@RoleId
						FROM CTE


						 /* Deny Permissions.......*/
						INSERT INTO UserManagement.UserPrivileges(NavigationMenusFkId,PrivilegeActionsFkId,UsersFkId,
						IsGranted,IsDeny,IsActive,CreatedBy,CreatedDate)
							SELECT B.NavigationMenusFkId , B.PrivilegeActionsFkId ,@UserId ,--1,
							0,1,1,@UserId,GETDATE()
							FROM UserManagement.RolesPrivileges B 
							LEFT OUTER JOIN @tmp  A ON (B.NavigationMenusFkId=A.PageId AND B.PrivilegeActionsFkId =A.PrivegesId )--and B.DesignationId = A.DesignationId
							WHERE B.RolesFkId =@RoleId 
								  AND A.Id IS NULL;
							  
							  
						/* Extra Permissions.......*/
						INSERT INTO UserManagement.UserPrivileges(NavigationMenusFkId,PrivilegeActionsFkId,UsersFkId,
						IsGranted,IsDeny,IsActive,CreatedBy,CreatedDate)
							SELECT A.PageId , A.PrivegesId,@UserId ,--1,
							1,0,1,@UserId,GETDATE()
							FROM @tmp  A
							LEFT OUTER JOIN UserManagement.RolesPrivileges B  ON (B.NavigationMenusFkId=A.PageId AND B.PrivilegeActionsFkId=A.PrivegesId and B.RolesFkId = A.RoleId )
							WHERE
							  B.Id IS NULL  	
						

						/* If It's Role has no privileges defined, then insert the all given privileges..*/
						IF NOT EXISTS(SELECT 1 FROM UserManagement.RolesPrivileges WHERE RolesFkId = @RoleId )
						BEGIN
							INSERT INTO UserManagement.UserPrivileges(NavigationMenusFkId,PrivilegeActionsFkId,UsersFkId,--IsTrue,
							IsGranted,IsDeny,IsActive,CreatedDate)
								SELECT PageId,PrivegesId,@UserId,
									   1,0,1,GETDATE()
									   FROM @tmp;
						END

						
						
				 END
				ELSE /* Else revoke all.*/
				BEGIN						 
						
							
							/* Insert new alloted privileges...*/
							INSERT INTO UserManagement.UserPrivileges(NavigationMenusFkId,PrivilegeActionsFkId,UsersFkId,--IsTrue,
							IsGranted,IsDeny,IsActive,CreatedBy,CreatedDate)
							SELECT B.NavigationMenusFkId , B.PrivilegeActionsFkId ,@UserId ,--1,
							0,1,1,@UserId,GETDATE()
							FROM UserManagement.RolesPrivileges B 
							WHERE B.RolesFkId =@RoleId;
								
									
				END
				/*--------------------------------------------------------------*/
				IF @@TRANCOUNT > 0
					BEGIN COMMIT TRANSACTION trans;

					SET @ReturnResult = 'PermissionsGranted';
				    SET @ReturnStatus = 1;
				END
		 END TRY
	 	 BEGIN CATCH
				SELECT 0
				  --SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
				IF @@TRANCOUNT > 0
					BEGIN ROLLBACK TRANSACTION trans ;
					SET @ReturnResult = 'PermissionsFailed';
					SET @ReturnStatus = 0;
				END
		 END CATCH 
		
	SELECT @ReturnResult AS ReturnResult, @ReturnStatus AS ReturnStatus;
		

		
END

  






GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique Email Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AspNetUsers', @level2type=N'CONSTRAINT',@level2name=N'IX_AspNetUsers_UniqueEmailNUserType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique Phone Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AspNetUsers', @level2type=N'CONSTRAINT',@level2name=N'IX_AspNetUsers_UniquePhoneNumberNUserType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Verfication For - Email or Mobile.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AspNetUsersEmailMobileVerification', @level2type=N'COLUMN',@level2name=N'VerificationForFkId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DefaultSqlDataTypes', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If true than nobody can delete this row' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Roles', @level2type=N'COLUMN',@level2name=N'IsEditable'
GO
USE [master]
GO
ALTER DATABASE [ODC_PMS_Auth] SET  READ_WRITE 
GO
