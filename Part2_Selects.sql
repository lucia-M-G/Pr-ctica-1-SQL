-- Jordi Fernández, Joan Navió i Lucía Martínez
-- 0848: Base de Dades | Curs 2024 - 2025
-- Pràctica_SQL_Part2_v1.1

-- 1) Quants estadis hi ha?
SELECT PF.startcontract AS Year, 
       ROUND(AVG(PF.Salary), 2) AS AvgSalary
FROM player_franchise PF
GROUP BY PF.startcontract
ORDER BY PF.startcontract;

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

-- 8) Tenim guardat els colors dels seients de tots els estadis. Retorna quants seients blaus hi ha en total.

-- 9) Retorna la mitjana de seients (arrodonint sense decimals) per color d’entre tots els estadis. Quina es la mitjana dels platejats?

-- 10) Retorna els entrenadors principals amb el seu rendiment segons el salari (rendiment = (VictoryPercentage / 100) * (Salary / 1000)),
-- tallant els decimals que resultin. Quin és el rendiment de l'entrenador 100000004?

-- 11) Per cada equip retorna quantes vegades ha guanyat. Sempre que siguin 3 vegades o més. Quantes files retorna el select?

-- 12) Retorna amb el país i any els equips nacionals amb el nom i cognom del seu entrenador. Fes-ho pels anys del 2010 al 2015 i pels
-- països que comencin per A. Quants entrenadors retorna la consulta?

-- 13) Per un any específic retorna per cada equip la suma dels salaris dels seus jugadors. Asumeix que tots els jugadors que tenen un
-- contracte en qualsevol data de l'any 2007 s'ha de contabilitzar. Quin és el presupost dels Houston Rockets?

-- 14) Retorna cada arena amb la seva capacitat, juntament amb el nombre de seients que tenen. Quants seients té el Footprint Center?

-- 15) Crea un informe amb tots els jugadors que no son dels Estats Units ni d'Espanya. Inclou-ne tota la seva informació personal
-- completa. Ordena els resultats per nacionalitat i data de naixement ascendent. Quina és la ID del terncer juador retornat?

-- 16) Mostra un informe amb el nom, cognom i data de naixement de tots els caps d'entrenadors assistents de l'especialitat de psicologia
-- sense repetits i que tenen una data de naixement registrada. Ordena per cognom i nom. Quin és l'any de naixement del tercer resultat?

-- 17) Volem saber quantes franquícies hi ha per a cada conferència. Mostra totes les dades relacionades amb la conferència i un nou camp
-- amb el recompte. Quantes franquícies hi ha acada conferència?

-- 18) Sabent que molts jugadors han estat seleccionats en algun moment per les seves seleccions, retorna tots els jugadors que han estat
-- seleccionats en l'any 2010. Inclou IDCard, Nom, Cognom, Nacionalitat, Any de selecció, en aquell mateix any i el número de samarreta en
-- la selecció. Ordena el resultat pel numero de samarreta. Quina es al nacionalitat del primer resultat que apareix?

-- 19) Retorna el ID, nom i cognom dels jugadors i les dades del seu draft si es que en tenen. Ordena per cognom i any de draft. Quina es
-- la ID del primer resultat?

-- 20) Retorna les franquícies que han jugat a totes les temporades regulars registrades. Ordena alfabèticament de la Z a la A.
-- I tornaúnicament el 3 resultat.Quin és el nom del equip?

-- 21) Per cada especialitat d'entrenadors assistents, retorna quants n'ha tingut cada franquícia. Qunatsmetges tenen els Brooklin Nets?

-- 22) Troba quantes persones han nascut en un any en el qual no hi ha registrat un draft.

-- 23) Quants entrenadors cobren més que qualsevol jugador?

-- 24) Omple la columna NBARings de la taula de Franquícies. Aquest camp es pot calcular mitjançant la taula Franchise_Season contant quantes
-- vegades han guanyat. Utilitza una declaració UPDATE. Un cop ho tingueu, trobeu quantes franquícies tenen 4 o més anells.

-- 25) Troba el nom de la franquícia amb el valor de budjet més petit.

-- 26) Troba la ciutat de l'arena que tingui més seients sempre i quan siguin més de 18000 (veure taules seat i arena, NO utilitzar Capacity).

-- 27) Retorna la ID del jugador i el nom de la seva franquicia que han quedat primers al draft i al mateix any d'aquest han gunayat la
-- temporada regular. Retorna la ID de l'únic que te Universitat d'origen.

-- 28) Retorna els paisos amb més de 50 jugadors, 3 entrenadors i 10 assistents de paisos que tinguin selecció. Quin país apareix als resultats?

-- 29) Retorna els headcoach que entrenin equips nacionals amb el salari més gran o el percentantge de victòria més petit, d'entre els que
-- entrenen equips nacionals. Quan sumen els salaris dels entrenadors resultants?

-- 30) Retorna els jugadors que han jugat en 2 equips o més i han estat convocats també a la selecció més d'un cop. Qunats jugadors hi ha en
-- aquesta situació?