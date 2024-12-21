USE [master]
GO
/****** Object:  Database [30_Seconds]    Script Date: 12/2/2024 7:10:36 PM ******/
CREATE DATABASE [30_Seconds]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'30_Seconds', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\30_Seconds.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'30_Seconds_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\30_Seconds_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [30_Seconds] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [30_Seconds].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [30_Seconds] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [30_Seconds] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [30_Seconds] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [30_Seconds] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [30_Seconds] SET ARITHABORT OFF 
GO
ALTER DATABASE [30_Seconds] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [30_Seconds] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [30_Seconds] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [30_Seconds] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [30_Seconds] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [30_Seconds] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [30_Seconds] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [30_Seconds] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [30_Seconds] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [30_Seconds] SET  DISABLE_BROKER 
GO
ALTER DATABASE [30_Seconds] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [30_Seconds] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [30_Seconds] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [30_Seconds] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [30_Seconds] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [30_Seconds] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [30_Seconds] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [30_Seconds] SET RECOVERY FULL 
GO
ALTER DATABASE [30_Seconds] SET  MULTI_USER 
GO
ALTER DATABASE [30_Seconds] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [30_Seconds] SET DB_CHAINING OFF 
GO
ALTER DATABASE [30_Seconds] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [30_Seconds] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [30_Seconds] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [30_Seconds] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'30_Seconds', N'ON'
GO
ALTER DATABASE [30_Seconds] SET QUERY_STORE = OFF
GO
USE [30_Seconds]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_calc_age]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_calc_age](@dob date)
RETURNS int
AS
BEGIN
	
	
	RETURN datediff(yy,@dob,getdate())


END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_roll_dice]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[fn_roll_dice]()

returns int

as begin
	declare @num int;
	select @num = Value from vw_getRANDValue
	return @num
end
GO
/****** Object:  Table [dbo].[tbl_player]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_player](
	[player_id] [int] IDENTITY(1,1) NOT NULL,
	[player_name] [varchar](100) NULL,
	[email] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[player_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_team]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_team](
	[team_id] [int] IDENTITY(1,1) NOT NULL,
	[team_name] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[team_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_team_player]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_team_player](
	[team_id] [int] NOT NULL,
	[player_id] [int] NOT NULL,
 CONSTRAINT [PK_tbl_team_player] PRIMARY KEY CLUSTERED 
(
	[team_id] ASC,
	[player_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_score]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_score](
	[score_id] [int] IDENTITY(1,1) NOT NULL,
	[game_id] [int] NULL,
	[player_id] [int] NULL,
	[dice] [int] NULL,
	[score] [int] NULL,
 CONSTRAINT [PK__tbl_scor__8CA190505095139E] PRIMARY KEY CLUSTERED 
(
	[score_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_results]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/

create view [dbo].[vw_results]
as
SELECT team_name
      ,[game_id]
      
      ,[dice]
      ,[score]
  FROM [dbo].[tbl_score] s
  inner join tbl_player p
  on s.player_id = p.player_id
  inner join tbl_team_player tp
  on p.player_id = tp.player_id
  inner join tbl_team t
  on t.team_id = tp.team_id
GO
/****** Object:  View [dbo].[vw_final_result]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
create view [dbo].[vw_final_result]
as
select team_name,game_id,sum(abs(score-dice)) t_score 
from  vw_results
group by team_name,game_id

GO
/****** Object:  Table [dbo].[game]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game](
	[game_id] [int] IDENTITY(1,1) NOT NULL,
	[game_name] [varchar](500) NULL,
	[game_description] [varchar](max) NULL,
 CONSTRAINT [PK_game] PRIMARY KEY CLUSTERED 
(
	[game_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_game_team]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_game_team](
	[game_id] [int] NOT NULL,
	[team_id] [int] NOT NULL,
 CONSTRAINT [PK_tbl_game_team] PRIMARY KEY CLUSTERED 
(
	[game_id] ASC,
	[team_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_games]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_games]
AS
SELECT g.game_id, g.game_name, g.game_description, gt.game_id AS Expr1, gt.team_id, t.team_id AS Expr2, t.team_name, pt.team_id AS Expr3, pt.player_id, pl.player_id AS Expr4, pl.player_name, pl.email
FROM     dbo.game AS g INNER JOIN
                  dbo.tbl_game_team AS gt ON gt.game_id = g.game_id INNER JOIN
                  dbo.tbl_team AS t ON t.team_id = gt.team_id INNER JOIN
                  dbo.tbl_team_player AS pt ON pt.team_id = t.team_id INNER JOIN
                  dbo.tbl_player AS pl ON pl.player_id = pt.player_id
GO
/****** Object:  View [dbo].[vw_getRANDValue]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_getRANDValue]
AS
SELECT FLOOR(RAND()*(3)) AS Value
GO
/****** Object:  Table [dbo].[tbl_card]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_card](
	[card_id] [int] IDENTITY(1,1) NOT NULL,
	[question_id] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[card_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_questions]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_questions](
	[question_id] [int] IDENTITY(1,1) NOT NULL,
	[question] [varchar](100) NULL,
 CONSTRAINT [PK_tbl_questions] PRIMARY KEY CLUSTERED 
(
	[question_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[temp_card]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[temp_card](
	[question] [varchar](100) NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[game] ON 

INSERT [dbo].[game] ([game_id], [game_name], [game_description]) VALUES (21, N'God of War', N'God of War')
SET IDENTITY_INSERT [dbo].[game] OFF
GO
INSERT [dbo].[tbl_game_team] ([game_id], [team_id]) VALUES (21, 26)
INSERT [dbo].[tbl_game_team] ([game_id], [team_id]) VALUES (21, 27)
INSERT [dbo].[tbl_game_team] ([game_id], [team_id]) VALUES (21, 28)
GO
SET IDENTITY_INSERT [dbo].[tbl_player] ON 

INSERT [dbo].[tbl_player] ([player_id], [player_name], [email]) VALUES (31, N'Test', N'test')
INSERT [dbo].[tbl_player] ([player_id], [player_name], [email]) VALUES (32, N'Jabulile Matukane', N'Jabulile.matukane@absa.africa')
INSERT [dbo].[tbl_player] ([player_id], [player_name], [email]) VALUES (33, N'Mmatsiane Mokgatlhe', N'Mmatsiane.Mokgatlhe@absa.africa')
INSERT [dbo].[tbl_player] ([player_id], [player_name], [email]) VALUES (34, N'Nomfundo Luthuli', N'Nomfundo.Luthuli@absa.africa')
INSERT [dbo].[tbl_player] ([player_id], [player_name], [email]) VALUES (35, N'Xola Ngece', N'xola.ngece@absa.africa')
INSERT [dbo].[tbl_player] ([player_id], [player_name], [email]) VALUES (36, N'Gomolemo Senge', N'gomolemo.senge@absa.africa ')
INSERT [dbo].[tbl_player] ([player_id], [player_name], [email]) VALUES (37, N'Ammaarah Fakier', N'ammaarah.fakier@absa.africa')
INSERT [dbo].[tbl_player] ([player_id], [player_name], [email]) VALUES (38, N'Romeo Masike', N'romeo.masike@absa.africa')
SET IDENTITY_INSERT [dbo].[tbl_player] OFF
GO
SET IDENTITY_INSERT [dbo].[tbl_questions] ON 

INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (1, N'911')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (2, N'Nelson Mandela')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (3, N'Diego Maradona')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (4, N'Pele')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (5, N'David Beckham')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (6, N'Limpopo')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (7, N'Harare')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (8, N'Sun City')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (9, N'Cape Town')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (10, N'Faraday')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (11, N'Leonardo')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (12, N'Miriam Makeba')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (13, N'Pepsi')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (14, N'Ginger')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (15, N'Robert Mugabe')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (16, N'Hitler')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (17, N'Ryan Gosling')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (18, N'Tina Turner')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (19, N'Aluminium')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (20, N'Sony')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (21, N'Nintendo')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (22, N'BBC')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (23, N'CNN')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (24, N'Fox')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (25, N'Jupiter')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (26, N'Saturn')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (27, N'Jesus')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (28, N'Christmas')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (29, N'WWW')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (30, N'Amargeddon')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (31, N'Tetris')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (32, N'Shosholoza')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (33, N'Springboks')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (34, N'Russia')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (35, N'Cameroun')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (36, N'Botswana')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (37, N'Timberland')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (38, N'Zambia')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (39, N'Lusaka')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (40, N'Crocs')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (41, N'Michael Jordan')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (42, N'N1')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (43, N'SABC3')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (44, N'Prince Charles')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (45, N'Princess of Wales')
INSERT [dbo].[tbl_questions] ([question_id], [question]) VALUES (46, N'LG')
SET IDENTITY_INSERT [dbo].[tbl_questions] OFF
GO
SET IDENTITY_INSERT [dbo].[tbl_score] ON 

INSERT [dbo].[tbl_score] ([score_id], [game_id], [player_id], [dice], [score]) VALUES (1, 21, 32, 2, 3)
INSERT [dbo].[tbl_score] ([score_id], [game_id], [player_id], [dice], [score]) VALUES (2, 21, 33, 1, 4)
INSERT [dbo].[tbl_score] ([score_id], [game_id], [player_id], [dice], [score]) VALUES (3, 21, 34, 2, 5)
INSERT [dbo].[tbl_score] ([score_id], [game_id], [player_id], [dice], [score]) VALUES (4, 21, 35, 0, 3)
INSERT [dbo].[tbl_score] ([score_id], [game_id], [player_id], [dice], [score]) VALUES (5, 21, 36, 2, 2)
INSERT [dbo].[tbl_score] ([score_id], [game_id], [player_id], [dice], [score]) VALUES (6, 21, 37, 0, 4)
SET IDENTITY_INSERT [dbo].[tbl_score] OFF
GO
SET IDENTITY_INSERT [dbo].[tbl_team] ON 

INSERT [dbo].[tbl_team] ([team_id], [team_name]) VALUES (26, N'Buddies')
INSERT [dbo].[tbl_team] ([team_id], [team_name]) VALUES (28, N'CT Warriors')
INSERT [dbo].[tbl_team] ([team_id], [team_name]) VALUES (27, N'Sitting Ducks')
SET IDENTITY_INSERT [dbo].[tbl_team] OFF
GO
INSERT [dbo].[tbl_team_player] ([team_id], [player_id]) VALUES (26, 32)
INSERT [dbo].[tbl_team_player] ([team_id], [player_id]) VALUES (26, 33)
INSERT [dbo].[tbl_team_player] ([team_id], [player_id]) VALUES (26, 34)
INSERT [dbo].[tbl_team_player] ([team_id], [player_id]) VALUES (27, 35)
INSERT [dbo].[tbl_team_player] ([team_id], [player_id]) VALUES (27, 36)
INSERT [dbo].[tbl_team_player] ([team_id], [player_id]) VALUES (28, 37)
INSERT [dbo].[tbl_team_player] ([team_id], [player_id]) VALUES (28, 38)
GO
INSERT [dbo].[temp_card] ([question]) VALUES (N'Botswana')
INSERT [dbo].[temp_card] ([question]) VALUES (N'Zambia')
INSERT [dbo].[temp_card] ([question]) VALUES (N'Miriam Makeba')
INSERT [dbo].[temp_card] ([question]) VALUES (N'N1')
INSERT [dbo].[temp_card] ([question]) VALUES (N'Limpopo')
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [uc_player]    Script Date: 12/2/2024 7:10:37 PM ******/
ALTER TABLE [dbo].[tbl_player] ADD  CONSTRAINT [uc_player] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [uc_team]    Script Date: 12/2/2024 7:10:37 PM ******/
ALTER TABLE [dbo].[tbl_team] ADD  CONSTRAINT [uc_team] UNIQUE NONCLUSTERED 
(
	[team_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_game_team]  WITH CHECK ADD  CONSTRAINT [FK_tbl_game_team_game] FOREIGN KEY([game_id])
REFERENCES [dbo].[game] ([game_id])
GO
ALTER TABLE [dbo].[tbl_game_team] CHECK CONSTRAINT [FK_tbl_game_team_game]
GO
ALTER TABLE [dbo].[tbl_game_team]  WITH CHECK ADD  CONSTRAINT [FK_tbl_game_team_tbl_team] FOREIGN KEY([team_id])
REFERENCES [dbo].[tbl_team] ([team_id])
GO
ALTER TABLE [dbo].[tbl_game_team] CHECK CONSTRAINT [FK_tbl_game_team_tbl_team]
GO
ALTER TABLE [dbo].[tbl_team_player]  WITH CHECK ADD  CONSTRAINT [FK_tbl_team_player_tbl_player] FOREIGN KEY([player_id])
REFERENCES [dbo].[tbl_player] ([player_id])
GO
ALTER TABLE [dbo].[tbl_team_player] CHECK CONSTRAINT [FK_tbl_team_player_tbl_player]
GO
ALTER TABLE [dbo].[tbl_team_player]  WITH CHECK ADD  CONSTRAINT [FK_tbl_team_player_tbl_team] FOREIGN KEY([team_id])
REFERENCES [dbo].[tbl_team] ([team_id])
GO
ALTER TABLE [dbo].[tbl_team_player] CHECK CONSTRAINT [FK_tbl_team_player_tbl_team]
GO
/****** Object:  StoredProcedure [dbo].[sp_add_player_to_team]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_add_player_to_team](@team_id int, @player_id int)
as

insert into [dbo].[tbl_team_player]
select @team_id, @player_id

GO
/****** Object:  StoredProcedure [dbo].[sp_add_score]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_add_score] @game_id int,@player_id int,@dice int,@score int
as
INSERT INTO [dbo].[tbl_score]
           ([game_id]
		   ,[player_id]
           ,[dice]
           ,[score])
     VALUES
           (@game_id
           ,@player_id
           ,@dice
           ,@score)
GO
/****** Object:  StoredProcedure [dbo].[sp_addplayer]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_addplayer](@fullname varchar(200), @email varchar(100), @team_id int = 0)
as
declare @player_id int

insert into tbl_player
select @fullname, @email

select @player_id = @@IDENTITY

exec sp_add_player_to_team @team_id, @player_id

GO
/****** Object:  StoredProcedure [dbo].[sp_create_game]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_create_game] @game_name varchar(100), @game_desc varchar(MAX)
as
insert into [dbo].[game]
select @game_name,@game_desc
GO
/****** Object:  StoredProcedure [dbo].[sp_create_team]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_create_team] @team_name varchar(200), @game_id int
as

declare @team_id int
INSERT INTO [dbo].[tbl_team]
           
     select @team_name

select @team_id = @@IDENTITY

INSERT INTO [dbo].[tbl_game_team]
           select @team_id, @game_id


GO
/****** Object:  StoredProcedure [dbo].[sp_enter_score]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_enter_score] @game_id int,@player_id int , @dice int , @score int
as
insert into tbl_score
select @game_id,@player_id,@dice, @score
GO
/****** Object:  StoredProcedure [dbo].[sp_generate_card]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_generate_card]
as
declare @words_total int, @count int = 0
select @words_total = count(*) from tbl_questions

truncate table temp_card

while @count < 5
 begin
		insert into temp_card
		SELECT question from tbl_questions
		where question_id = FLOOR(RAND()*(@words_total+1));
		set @count = @count + 1


  end

  select * from temp_card
GO
/****** Object:  StoredProcedure [dbo].[sp_get_players]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_get_players]
as
select		player_id,player_name
from		tbl_player 
GO
/****** Object:  StoredProcedure [dbo].[sp_get_team_members]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_get_team_members] @team_id int = 2
as
select		t.team_id,
			t.team_name,
			p.player_id,
			player_name 
from		tbl_player p
inner join  tbl_team_player tp
on			p.player_id = tp.player_id
inner join	tbl_team t 
on			tp.team_id = t.team_id
where		t.team_id = @team_id
GO
/****** Object:  StoredProcedure [dbo].[sp_get_teams]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_get_teams]
as
select		t.team_id,
			t.team_name
from		tbl_team t 
order by team_id
GO
/****** Object:  StoredProcedure [dbo].[sp_pick_a_player]    Script Date: 12/2/2024 7:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_pick_a_player] @team int = 1
as

select		top 1 t.team_id,
			t.team_name,
			player_name 
from		tbl_player p
inner join  tbl_team_player tp
on			p.player_id = tp.player_id
inner join	tbl_team t 
on			tp.team_id = t.team_id
where		t.team_id = @team
order by	t.team_id
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "g"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 148
               Right = 261
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "gt"
            Begin Extent = 
               Top = 7
               Left = 309
               Bottom = 126
               Right = 503
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 7
               Left = 551
               Bottom = 126
               Right = 745
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pt"
            Begin Extent = 
               Top = 7
               Left = 793
               Bottom = 126
               Right = 987
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pl"
            Begin Extent = 
               Top = 7
               Left = 1035
               Bottom = 148
               Right = 1229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_games'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_games'
GO
USE [master]
GO
ALTER DATABASE [30_Seconds] SET  READ_WRITE 
GO
