# Chinook DB - Udacity SQL Project
# By Renan Critelli

-- Parte 1: Warm Up --

/*Pergunta 1: Quais países possuem mais faturas?
Use a tabela Invoice (Fatura) para determinar quais países possuem mais faturas. 
Forneça as tabelas de BillingCountry (país de cobrança) e Invoices (faturas) 
ordenadas pelo número de faturas para cada país. O país com mais faturas deve 
aparecer primeiro.*/
SELECT BillingCountry, COUNT(invoiceId) invoice_qty 
FROM invoice
GROUP BY BillingCountry
ORDER BY invoice_qty DESC;

/*Pergunta 2: Qual cidade tem os melhores clientes?
Gostaríamos de lançar um festival de música promocional na cidade que nos gerou 
mais dinheiro. Escreva uma consulta que retorna a cidade que possui a maior 
soma dos totais de fatura. Retorne tanto o nome da cidade quanto a soma de todos 
os totais de fatura.*/
SELECT BillingCity, SUM(total) total_expenditure
FROM invoice
GROUP BY BillingCity
ORDER BY total_expenditure DESC;

/*Pergunta 3: Quem é o melhor cliente?
O cliente que gastou mais dinheiro será declarado o melhor cliente. Crie uma 
consulta que retorna a pessoa que mais gastou dinheiro. Eu encontrei essa informação 
ao linkar três tabelas: Invoice (fatura), InvoiceLine (linha de faturamento), e 
Customer (cliente). Você provavelmente consegue achar a solução com menos tabelas!*/
SELECT i.CustomerId, c.firstname, SUM(i.total) total_expenditure
FROM invoice i
JOIN customer c ON i.customerid = c.customerid
GROUP BY customerId
ORDER BY total_expenditure DESC;
# Fiz join apenas para ver o nome, poderia não fazer e usar só customerId

/*Pergunta 4
Use sua consulta para retornar o e-mail, nome, sobrenome e gênero de todos 
os ouvintes de Rock. Retorne sua lista ordenada alfabeticamente por endereço 
de e-mail, começando por A. Você consegue encontrar um jeito de lidar com 
e-mails duplicados para que ninguém receba vários e-mails?*/
SELECT DISTINCT c.email, c.firstname, c.lastname, g.name
FROM customer c
JOIN invoice ON c.customerid = invoice.customerid
JOIN invoiceline ON invoice.invoiceid = invoiceline.InvoiceId
JOIN track t ON invoiceline.trackid = t.trackid
JOIN genre g ON t.genreid = g.genreid
WHERE g.name = 'Rock'
ORDER BY c.email;

/*Vamos convidar os artistas que mais escreveram as músicas de rock em nosso 
banco de dados. Escreva uma consulta que retorna o nome do Artist (artista) 
e a contagem total de músicas das dez melhores bandas de rock. Você precisará 
usar as tabelas Genre (gênero), Track (música) , Album (álbum), and Artist 
(artista).*/
SELECT a.artistid, a.name, COUNT(t.trackid) songs
FROM artist a
JOIN album ON a.artistid = album.ArtistId
JOIN track t ON album.AlbumId = t.AlbumId
JOIN genre ON t.GenreId = genre.GenreId
WHERE genre.name = 'Rock'
GROUP BY artistid
ORDER BY songs DESC;

# Artista que ganhou mais
SELECT a.artistid, a.name, SUM(il.unitprice*il.quantity) sales_revenue
FROM artist a
JOIN album ON a.artistid = album.ArtistId
JOIN track t ON album.AlbumId = t.AlbumId
JOIN invoiceLine il ON t.trackid = il.trackid
GROUP BY artistid
ORDER BY sales_revenue DESC;

# Cliente que gastou mais com Iron Maiden (artistid = 90)
SELECT c.customerid, c.firstName, c.LastName, SUM(il.unitprice*il.quantity) expenditure
FROM customer c
JOIN invoice ON c.customerid = invoice.customerid
JOIN invoiceLine il ON invoice.invoiceid = il.invoiceid
JOIN track ON il.trackid = track.trackid
JOIN album ON track.AlbumId = album.AlbumId
WHERE artistid = 90
GROUP BY c.customerid
ORDER BY expenditure DESC;

# Subqueries...

/*Queremos descobrir o gênero musical mais popular em cada país. Determinamos 
o gênero mais popular como o gênero com o maior número de compras. Escreva uma 
consulta que retorna cada país juntamente a seu gênero mais vendido. Para países 
onde o número máximo de compras é compartilhado retorne todos os gêneros.*/
SELECT maxsub.country, allsub.name preferred_genre, total
FROM (
	SELECT country, MAX(number_of_songs) total
	FROM (
		SELECT c.country, g.name, COUNT(il.invoicelineid)*il.Quantity number_of_songs
		FROM invoiceline il
		JOIN invoice i ON il.invoiceid = i.invoiceid
		JOIN customer c ON i.customerid = c.customerid
		JOIN track t ON il.trackid = t.trackid
		JOIN genre g ON t.genreid = g.genreid
		GROUP BY c.country, g.name
		ORDER BY c.country, number_of_songs DESC	# pode ser retirada
	    )t1
    GROUP BY country
    ) maxsub
JOIN (
     SELECT c.country, g.name, COUNT(il.invoicelineid)*il.Quantity number_of_songs
	 FROM invoiceline il
	 JOIN invoice i ON il.invoiceid = i.invoiceid
 	 JOIN customer c ON i.customerid = c.customerid
 	 JOIN track t ON il.trackid = t.trackid
	 JOIN genre g ON t.genreid = g.genreid
	 GROUP BY c.country, g.name
     ) allsub
    ON maxsub.country = allsub.country AND maxsub.total = allsub.number_of_songs
ORDER BY allsub.country;

/*Retorne todos os nomes de músicas que possuem um comprimento de canção maior 
que o comprimento médio de canção. Embora você possa fazer isso com duas 
consultas. Imagine que você queira que sua consulta atualize com base em onde 
os dados são colocados no banco de dados. Portanto, você não quer fazer um hard 
code da média na sua consulta. Você só precisa da tabela Track (música) para 
completar essa consulta. Retorne o Name (nome) e os Milliseconds (milissegundos) 
para cada música. Ordene pelo comprimento da canção com as músicas mais longas 
sendo listadas primeiro.*/
SELECT Name, Milliseconds
FROM track
WHERE Milliseconds > (
	SELECT AVG(Milliseconds)
	FROM track)
ORDER BY Milliseconds DESC;

/*Escreva uma consulta que determina qual cliente gastou mais em músicas por país. 
Escreva uma consulta que retorna o país junto ao principal cliente e quanto ele 
gastou. Para países que compartilham a quantia total gasta, forneça todos os 
clientes que gastaram essa quantia. Você só precisará usar as tabelas Customer 
(cliente) e Invoice (fatura).*/
SELECT allsub.*
FROM (SELECT c.Country, c.FirstName, c.LastName, SUM(i.total) gasto
	FROM invoice i
	JOIN customer c ON i.customerid = c.customerid
	GROUP BY c.customerid
	) allsub
JOIN (
	SELECT Country, MAX(gasto) max_spent
	FROM (
		SELECT c.Country, c.FirstName, c.LastName, SUM(i.total) gasto
		FROM invoice i
		JOIN customer c ON i.customerid = c.customerid
		GROUP BY c.customerid
        ) allsub
	GROUP BY country
	) keysub
ON allsub.country = keysub.country AND allsub.gasto = keysub.max_spent
ORDER BY country;

-- Parte 2: Projeto --

# 1. Qual o número de músicas por formato de mídia?
SELECT t.MediaTypeId, mt.name, COUNT(t.MediaTypeId) songs
FROM track t
JOIN mediatype mt ON t.MediaTypeId = mt.MediaTypeId
GROUP BY t.MediaTypeId;
# Qual o número de vendas por formato de mídia?
SELECT mt.MediaTypeId, mt.name media_type, SUM(il.Quantity) total_sales
FROM invoiceline il
JOIN track t ON il.trackid = t.trackid
JOIN mediatype mt ON t.MediaTypeId = mt.MediaTypeId
GROUP BY media_type
ORDER BY mt.MediaTypeId;

# 2. Duração das musicas que foram compradas (tem duplicata pois pode ser comprada mais de uma vez)
SELECT song_class, COUNT(song_class) num_sales
FROM (
	SELECT name song, Milliseconds/60000 minutes,
		CASE WHEN Milliseconds/60000 > 5 THEN 'long'
			WHEN Milliseconds/60000 BETWEEN 3 AND 5 THEN 'medium'
			ELSE 'short' END song_class
	FROM track t
	JOIN invoiceline il ON t.trackid = il.trackid
    ) sub
GROUP BY song_class
ORDER BY song_class DESC;

# 3. Qual a evolução anual das vendas?
SELECT YEAR(invoicedate) year, SUM(il.Quantity) total_sales
FROM invoice i
JOIN invoiceline il ON i.invoiceid = il.invoiceid
GROUP BY year;

# 4. Investigando "fidelidade". Qual a evolução das compras dos primeiros clientes?
# Considerando apenas os clientes que compraram em 2009, qual o número de compras?
SELECT YEAR(InvoiceDate) year, SUM(il.Quantity) total_sales
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
JOIN invoiceline il ON i.invoiceid = il.invoiceid
WHERE c.CustomerId IN (
	SELECT c.CustomerId
	FROM customer c
	JOIN invoice i ON c.customerid = i.customerid
	WHERE YEAR(i.invoicedate) = 2009)
GROUP BY year
ORDER BY year;
