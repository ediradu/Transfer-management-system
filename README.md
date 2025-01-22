# Transfer-management-system

Acest proiect constă în dezvoltarea unui sistem de gestionare a transferurilor de fotbaliști între 
echipe. Baza de date va conține informații detaliate despre jucători, echipe, contracte și transferuri. 
Sistemul va urmări toate transferurile realizate, incluzând date despre sumele implicate, durata contractelor 
și echipele participante.

Cerințe preliminare:
- Microsoft SQL Server instalat;
- Python 3.10+ instalat;
- pip install pyodbc;
- pip install matplotlib.

Crearea bazei de date:
- Conectați-vă la SQL Server utilizând un client precum SQL Server Management Studio (SSMS);
- creați o bază de date cu denumirea football_transfers;
- rulați CreateTables.sql pentru crearea tabelelor;
- rulați Populate....sql pentru popularea tabelelor;
- rulați restul scripturilor pentru constrângeri, trigere și proceduri.

Rularea aplicației:
- modificați script.py în funcție de ce user și parolă folosiți;
- rulați python script.py;
- o să vedeți graficele. 

Structura bazei de date include șase tabele principale, fiecare având un rol bine definit în 
organizarea datelor și interconectate prin relații logice. Tabelul players stochează informațiile esențiale 
despre jucători, precum numele, naționalitatea, poziția pe teren, data nașterii și valoarea lor de piață. 
Fiecare jucător este identificat unic prin player_id, care este utilizat ca cheie primară și apare ca cheie 
străină în alte tabele precum contracts, transfers și player_stats, creând astfel relații de tip one-to-many. 
Tabelul teams reprezintă echipele de fotbal și include informații despre numele echipei, țara de proveniență 
și bugetul acesteia. Fiecare echipă este asociată cu o ligă prin intermediul coloanei league_id, care este o 
cheie străină ce face legătura cu tabelul leagues. Această relație este de tip many-to-one, indicând faptul 
că mai multe echipe pot aparține unei singure ligi. Tabelul leagues conține date despre ligile de fotbal, 
inclusiv numele lor și țara în care operează. Acesta este punctul de legătură pentru tabelul teams, stabilind 
o relație logică în care ligile organizează echipele. Pentru a urmări relațiile dintre jucători și echipe, tabelul 
contracts înregistrează toate detaliile contractelor semnate, cum ar fi durata acestora, salariul oferit și 
echipa cu care a fost încheiat contractul. Acest tabel conectează jucătorii și echipele prin intermediul cheilor 
străine player_id și team_id, stabilind relații de tip many-to-one cu fiecare dintre aceste tabele. Transferurile 
jucătorilor între echipe sunt gestionate în tabelul transfers, care include informații despre echipele de 
plecare și de destinație, taxa de transfer și data la care a avut loc transferul. Relația dintre transfers și 
teams este de tip many-to-one, prin intermediul coloanelor from_team_id și to_team_id, iar relația cu 
players este, de asemenea, many-to-one, indicând faptul că un jucător poate fi transferat de mai multe ori. 
Performanțele jucătorilor sunt detaliate în tabelul player_stats, care conține date despre numărul de goluri 
marcate, pase decisive, meciuri jucate și minute pe teren. Fiecare rând din acest tabel este asociat cu un 
jucător specific prin intermediul player_id, stabilind o relație de tip one-to-one sau one-to-many, în funcție 
de structura și utilizarea acestuia. 

Constrângerile de integritate asigură corectitudinea și consistența datelor din baza de date. Pentru 
tabela players, valoarea de piață trebuie să fie pozitivă, iar pentru teams, bugetul și numele echipei sunt 
validate prin constrângeri de unicitate și verificări ale valorilor pozitive. În leagues, se asigură unicitatea 
numelui și existența unei denumiri valide. Tabela contracts impune ca salariile să fie pozitive, iar intervalele 
de timp ale contractelor să fie logice, garantând unicitatea relației jucător-echipă. În transfers, taxa de 
transfer este verificată pentru a nu fi negativă, iar durata contractului trebuie să fie pozitivă. Aceste reguli 
protejează integritatea relațiilor și a datelor din tabelele bazei. 

Triggerele din baza de date sunt utilizate pentru a automatiza verificările și actualizările la 
evenimente precum inserări sau modificări. Triggerul ValidateContractDuration asigură că durata 
contractelor 
este de cel puțin un an, prevenind inserarea datelor invalide. Triggerul 
UpdateTeamBudgetAfterTransfer scade taxa de transfer din bugetul echipei care primește jucătorul, în timp 
ce UpdateBudgetForFromTeam adaugă această sumă în bugetul echipei care cedează jucătorul. Pentru a 
preveni transferurile nefezabile, CheckBudgetForToTeam și CheckBudgetBeforeTransfer verifică dacă 
echipa primitoare are un buget suficient pentru taxa de transfer, blocând tranzacția dacă acest lucru nu 
este îndeplinit. 

Procedurile stocate din baza de date sunt utilizate pentru a genera rapoarte complexe și pentru a 
extrage date relevante într-un mod optimizat. Procedura GetTopPlayersByLeague identifică cei mai 
performanți jucători din fiecare ligă, utilizând metrici precum golurile marcate și minutele jucate. 
Rezultatele sunt reprezentate grafic într-un bar chart detaliat, unde fiecare jucător este reprezentat pe 
axa X, iar numărul de goluri pe axa Y. Culorile diferite sunt utilizate pentru a indica ligile din care provin 
jucătorii, iar o legendă amplasată sub grafic asigură claritatea interpretării. Procedura 
GetLeaguesWithMostForeignPlayers analizează numărul de jucători străini din fiecare ligă, evidențiind 
diversitatea internațională a echipelor. Datele sunt prezentate într-un grafic de tip bară, în care ligile sunt 
afișate pe axa X și numărul de jucători străini pe axa Y. Acest grafic simplu oferă o perspectivă rapidă 
asupra ligilor cu cea mai mare diversitate internațională. GetLeaguesWithHighestSalaries sumarizează și 
compară salariile totale și medii din fiecare ligă pentru anul anterior. Aceste date sunt reprezentate într-un 
grafic de tip stacked bar, în care axa X indică ligile, iar axa Y afișează atât salariile totale, cât și salariile 
medii. Culorile distincte pentru fiecare componentă financiară și legenda aferentă permit identificarea 
clară a diferențelor financiare dintre ligi.

Conexiunea aplicației la baza de date este realizată prin intermediul metodei openConnection 
definită în clasa MSSQLConnection. Această metodă utilizează biblioteca pyodbc pentru a iniția o 
conexiune cu serverul SQL. Parametrii necesari, cum ar fi DRIVER, SERVER, DATABASE, UID 
(username), PWD (parola) și alte setări de securitate, sunt specificați într-un șir de conectare. În cadrul 
acestei metode, conexiunea la baza de date este stabilită utilizând funcția pyodbc.connect, iar un cursor 
este creat pentru a permite executarea de interogări SQL și proceduri stocate. Procedurile SQL sunt apelate 
în aplicație prin intermediul metodei fetchData, care utilizează cursorul pentru a executa comenzi SQL 
folosind cuvântul cheie EXEC, urmat de numele procedurii și, dacă este cazul, parametrii necesari. După 
finalizarea operațiunilor, conexiunea este închisă în mod controlat prin metoda closeConnection, care 
închide atât cursorul, cât și conexiunea activă la baza de date. 

Acest proiect evidențiază o abordare practică și eficientă în gestionarea datelor despre transferuri 
și performanțe fotbalistice. Printr-o bază de date bine structurată, constrângeri de integritate și utilizarea 
procedurilor stocate, s-au obținut rapoarte clare și relevante. Integrarea cu Python și utilizarea graficelor 
au făcut analiza datelor mai intuitivă și ușor de înțeles.
