-- Jordi Fernández, Joan Navió i Lucía Martínez
-- 0848: Base de Dades | Curs 2024 - 2025
-- Pràctica_SQL_Part2_v1.1

-- 1) Quants estadis hi ha?
SELECT COUNT(*) AS NombreEstadis FROM arena;

-- 2) Obté el nom i cognom de l'entrenador principal de cada franquícia. Quin és el cognom de l'entrenador de Utah Jazz?
SELECT P.Surname
FROM franchise F
JOIN headcoach H ON F.IDCardCoach = H.IDCard
JOIN person P ON H.IDCard = P.IDCard
WHERE F.Name = 'Utah Jazz';

-- 3) Troba el nom de la franquícia amb el pressupost més gran.
SELECT Budget
	FROM franchise
	ORDER BY Budget DESC
	LIMIT 1;

-- 4) Llista les arenes (noms i ciutats) de les franquícies de la conferència oest. Quin és el nom de la 5a ciutat?
SELECT SUBSTRING_INDEX(A.City, ',', 1) AS CityName
	 FROM arena A
	 JOIN franchise F ON A.Name = F.ArenaName
	 WHERE F.ConferenceName = 'Western Conference'
	 ORDER BY A.City
	 LIMIT 1 OFFSET 4;

-- 5) Llista els noms dels jugadors que han estat seleccionats en el draft en primera, segona o tercera posició al draft
-- del 2020. Ordena pel cognom i nom del jugador (Z-A). Quin és el nom del jugador mostrat en la primera fila?
SELECT pe.Name
		 FROM person pe
		 JOIN player pl ON pe.IDCard = pl.IDCard
		 JOIN draft_player_franchise dpf ON pl.IDCard = dpf.IDCardPlayer
		 WHERE dpf.DraftYear = 2020 AND dpf.Position IN (1, 2, 3)
		 ORDER BY pe.Surname DESC, pe.Name DESC
		 LIMIT 1;

-- 6) Recupera els noms dels jugadors que tenen una data de naixement anterior al març de 1980. Quin és el nom del jugador de cognom
-- Lue que apareix als primers resultats?
SELECT Pe.Name
	FROM person Pe
	JOIN player Pl ON Pl.IDCard = Pe.IDCard 
	WHERE Pe.Surname = 'Lue'
		AND Pe.BirthDate < '1980-03-01';

-- 7) Per cada arena, digues el nombre de seients VIP que hi ha. Quants en te el Madison Square Garden?
SELECT COUNT(*) AS NumVIPSeats
			FROM seat S
			JOIN zone Z ON Z.code = S.ZoneCode AND Z.ArenaName = S.ArenaName 
			WHERE Z.ArenaName = 'Madison Square Garden'
				AND Z.IsVip = 1;

-- 8) Tenim guardat els colors dels seients de tots els estadis. Retorna quants seients blaus hi ha en total.
SELECT COUNT(*) AS Total_Seients_Blaus 
FROM seat 
WHERE Color = 'Blue';

-- 9) Retorna la mitjana de seients (arrodonint sense decimals) per color d’entre tots els estadis. Quina es la mitjana dels platejats?
SELECT Color, ROUND(AVG(SeatCount), 0) AS AvgSeats
FROM (
    SELECT Color, ArenaName, COUNT(*) AS SeatCount
    FROM seat
    GROUP BY Color, ArenaName
) AS SeatPerArena
GROUP BY Color;

-- 10) Retorna els entrenadors principals amb el seu rendiment segons el salari (rendiment = (VictoryPercentage / 100) * (Salary / 1000)),
-- tallant els decimals que resultin. Quin és el rendiment de l'entrenador 100000004?
SELECT TRUNCATE((VictoryPercentage / 100) * (Salary / 1000), 0) AS CalculatedValue
			FROM headcoach
			WHERE IDCard = 100000004;

-- 11) Per cada equip retorna quantes vegades ha guanyat. Sempre que siguin 3 vegades o més. Quantes files retorna el select?
SELECT COUNT(*) AS Num_Teams
FROM (
    SELECT F.Name
    FROM franchise_season FS
    JOIN franchise F ON FS.FranchiseName = F.Name
    WHERE FS.IsWinner = TRUE
    GROUP BY F.Name
    HAVING COUNT(*) >= 3
) AS Subquery;

-- 12) Retorna amb el país i any els equips nacionals amb el nom i cognom del seu entrenador. Fes-ho pels anys del 2010 al 2015 i pels
-- països que comencin per A. Quants entrenadors retorna la consulta?
SELECT NT.Country, NT.Year, P.Name, P.Surname
FROM nationalteam NT
JOIN person P ON P.IDCard = NT.IDCardHeadCoach
WHERE NT.Year BETWEEN 2010 AND 2015
  AND NT.Country LIKE 'A%'
ORDER BY NT.Country, NT.Year;

-- 13) Per un any específic retorna per cada equip la suma dels salaris dels seus jugadors. Asumeix que tots els jugadors que tenen un
-- contracte en qualsevol data de l'any 2007 s'ha de contabilitzar. Quin és el presupost dels Houston Rockets?
SELECT PF.FranchiseName, SUM(PF.Salary )
			FROM player_franchise PF
			WHERE YEAR(PF.StartContract) = 2007
			GROUP BY PF.FranchiseName ;

-- 14) Retorna cada arena amb la seva capacitat, juntament amb el nombre de seients que tenen. Quants seients té el Footprint Center?
SELECT A.Name AS ArenaName, A.Capacity, COUNT(S.Number) AS Total_Seats
FROM arena A
JOIN seat S ON A.Name = S.ArenaName
WHERE A.Name = 'Footprint Center'
GROUP BY A.Name, A.Capacity;

-- 15) Crea un informe amb tots els jugadors que no son dels Estats Units ni d'Espanya. Inclou-ne tota la seva informació personal
-- completa. Ordena els resultats per nacionalitat i data de naixement ascendent. Quina és la ID del terncer juador retornat?
SELECT Pe.* 
	FROM person Pe
	JOIN player Pl ON Pe.IDCard = Pl.IDCard
	WHERE Pe.Nationality NOT IN ('United States', 'Spain')
	ORDER BY Pe.Nationality, Pe.BirthDate;

-- 16) Mostra un informe amb el nom, cognom i data de naixement de tots els caps d'entrenadors assistents de l'especialitat de psicologia
-- sense repetits i que tenen una data de naixement registrada. Ordena per cognom i nom. Quin és l'any de naixement del tercer resultat?
SELECT DISTINCT p.IDCard, p.Name, p.Surname, p.BirthDate  
		FROM person p  
		JOIN assistantcoach a ON p.IDCard = a.IDCard  
		WHERE a.IDCard IN (SELECT DISTINCT IDCardBoss FROM assistantcoach WHERE IDCardBoss IS NOT NULL)  
		AND p.BirthDate IS NOT NULL  
		AND a.Especiality = Psychologist
		ORDER BY p.Surname, p.Name;

-- 17) Volem saber quantes franquícies hi ha per a cada conferència. Mostra totes les dades relacionades amb la conferència i un nou camp
-- amb el recompte. Quantes franquícies hi ha acada conferència?
SELECT C.Name AS ConferenceName, C.GeographicZone, COUNT(F.Name) AS TotalFranchises
FROM conference C
LEFT JOIN franchise F ON C.Name = F.ConferenceName
GROUP BY C.Name, C.GeographicZone;

-- 18) Sabent que molts jugadors han estat seleccionats en algun moment per les seves seleccions, retorna tots els jugadors que han estat
-- seleccionats en l'any 2010. Inclou IDCard, Nom, Cognom, Nacionalitat, Any de selecció, en aquell mateix any i el número de samarreta en
-- la selecció. Ordena el resultat pel numero de samarreta. Quina es al nacionalitat del primer resultat que apareix?
SELECT 
    p.IDCard,
    p.Name,
    p.Surname,
    p.Nationality,
    ntp.Year AS SelectionYear,
    ntp.ShirtNumber
FROM nationalteam_player ntp
JOIN person p ON ntp.IDCard = p.IDCard
WHERE 
    ntp.Year = 2010
ORDER BY 
    ntp.ShirtNumber;

-- 19) Retorna el ID, nom i cognom dels jugadors i les dades del seu draft si es que en tenen. Ordena per cognom i any de draft. Quina es
-- la ID del primer resultat?
SELECT P.IDCard, PR.Name, PR.Surname, DPF.DraftYear, DPF.FranchiseName, DPF.Position
	FROM player P
	JOIN person PR ON P.IDCard = PR.IDCard
	LEFT JOIN draft_player_franchise DPF ON P.IDCard = DPF.IDCardPlayer
	ORDER BY PR.Surname ASC, DPF.DraftYear ASC;

-- 20) Retorna les franquícies que han jugat a totes les temporades regulars registrades. Ordena alfabèticament de la Z a la A.
-- I tornaúnicament el 3 resultat.Quin és el nom del equip?
SELECT F.Name 
FROM franchise F
JOIN franchise_season FS ON F.Name = FS.FranchiseName
GROUP BY F.Name
HAVING COUNT(FS.RegularSeasonYear) = (SELECT COUNT(DISTINCT Year) FROM regularseason)
ORDER BY F.Name DESC
LIMIT 1 OFFSET 2;

-- 21) Per cada especialitat d'entrenadors assistents, retorna quants n'ha tingut cada franquícia. Qunatsmetges tenen els Brooklin Nets?
SELECT AC.Especiality, F.Name, COUNT(*) AS NumAssistants
	FROM assistantcoach AC
	JOIN franchise F ON AC.FranchiseName = F.Name
	GROUP BY AC.Especiality, F.Name
	ORDER BY F.Name;

-- 22) Troba quantes persones han nascut en un any en el qual no hi ha registrat un draft.
SELECT COUNT(*) 
	FROM person Pe
	WHERE NOT EXISTS ( SELECT Year FROM draft D WHERE YEAR(Pe.birthDate) = D.Year)
		AND YEAR(Pe.BirthDate) IS NOT NULL ORDER BY Pe.IDCard;

-- 23) Quants entrenadors cobren més que qualsevol jugador?
SELECT COUNT(*) AS Num_Entrenadors
FROM headcoach
WHERE Salary > (SELECT MAX(Salary) FROM player_franchise);

-- 24) Omple la columna NBARings de la taula de Franquícies. Aquest camp es pot calcular mitjançant la taula Franchise_Season contant quantes
-- vegades han guanyat. Utilitza una declaració UPDATE. Un cop ho tingueu, trobeu quantes franquícies tenen 4 o més anells.
UPDATE franchise F
SET F.NBARings = (
    SELECT COUNT(*)
    FROM franchise_season FS
    WHERE LOWER(FS.FranchiseName) = LOWER(F.Name) 
    AND FS.IsWinner = 1
);

SELECT Name, NBARings 
FROM franchise 
ORDER BY NBARings DESC;

SELECT COUNT(*) AS Num_Franquicies_4_Anells
FROM franchise
WHERE NBARings >= 4;

-- 25) Troba el nom de la franquícia amb el valor de budjet més petit.
SELECT F.name 
			FROM franchise F
			ORDER BY F.Budget ASC 
			LIMIT 1;

-- 26) Troba la ciutat de l'arena que tingui més seients sempre i quan siguin més de 18000 (veure taules seat i arena, NO utilitzar Capacity).
SELECT SUBSTRING_INDEX(A.City, ',', 1)
			FROM seat S
			JOIN arena A ON S.ArenaName = A.Name
			GROUP BY A.City, A.Name
			HAVING COUNT(S.Number) > 18000
			ORDER BY COUNT(S.Number) DESC
			LIMIT 1;

-- 27) Retorna la ID del jugador i el nom de la seva franquicia que han quedat primers al draft i al mateix any d'aquest han gunayat la
-- temporada regular. Retorna la ID de l'únic que te Universitat d'origen.
SELECT pf.IDCardPlayer, pf.FranchiseName
	FROM draft_player_franchise d
	JOIN player p ON p.IDCard = d.IDCardPlayer
	JOIN player_franchise pf ON pf.IDCardPlayer = p.IDCard 
	JOIN franchise f ON f.Name = pf.FranchiseName 
	JOIN franchise_season fs ON fs.FranchiseName = pf.FranchiseName 
		AND d.DraftYear = fs.RegularSeasonYear
	WHERE fs.IsWinner = 1
		AND d.Position = 1
		AND p.UniversityOfOrigin IS NOT NULL;

-- 28) Retorna els paisos amb més de 50 jugadors, 3 entrenadors i 10 assistents de paisos que tinguin selecció. Quin país apareix als resultats?
SELECT P.Nationality
FROM person P
LEFT JOIN player PL ON P.IDCard = PL.IDCard
LEFT JOIN headcoach HC ON P.IDCard = HC.IDCard
LEFT JOIN assistantcoach AC ON P.IDCard = AC.IDCard
JOIN nationalteam NT ON P.Nationality = NT.Country
GROUP BY P.Nationality
HAVING COUNT(DISTINCT PL.IDCard) > 50
   AND COUNT(DISTINCT HC.IDCard) > 3
   AND COUNT(DISTINCT AC.IDCard) > 10;

-- 29) Retorna els headcoach que entrenin equips nacionals amb el salari més gran o el percentantge de victòria més petit, d'entre els que
-- entrenen equips nacionals. Quan sumen els salaris dels entrenadors resultants?
SELECT 
		    (SELECT HC.Salary 
		     FROM headcoach HC
		     JOIN nationalteam NT ON NT.IDCardHeadCoach = HC.IDCard
		     ORDER BY HC.Salary DESC
		     LIMIT 1) 
			+
		    (SELECT HC.Salary 
		     FROM headcoach HC
		     JOIN nationalteam NT ON NT.IDCardHeadCoach = HC.IDCard
		     ORDER BY HC.VictoryPercentage
		     LIMIT 1) 
		AS SumlSalary;

-- 30) Retorna els jugadors que han jugat en 2 equips o més i han estat convocats també a la selecció més d'un cop. Qunats jugadors hi ha en
-- aquesta situació?
SELECT COUNT(*) AS NumJugadores
FROM (
    SELECT P.IDCard
    FROM player P
    JOIN player_franchise PF ON P.IDCard = PF.IDCardPlayer
    JOIN nationalteam_player NP ON P.IDCard = NP.IDCard
    GROUP BY P.IDCard
    HAVING COUNT(DISTINCT PF.FranchiseName) >= 2
       AND COUNT(DISTINCT NP.Year) > 1
) AS EligiblePlayers;