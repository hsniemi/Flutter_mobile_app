# Flutter_mobile_app
Sovelluksen esittely
Tämä sovellus on osa kesäprojektia, joka on Oulun ammattikorkeakoulun tietotekniikan tutkinto-ohjelman alakohtaista harjoittelua. Tekijä on Henna Niemi. Sovellus on tehty käyttäen Flutter-sovelluskehystä ja se on tarkoitettu apusovellukseksi marjojen, sienien tms. kerääjille. Sovelluksen avulla käyttäjä voi pitää kirjaa keräämästään sadosta, sekä tallettaa omia keräilypaikkoja ja tarkastella niitä kartalla. Lisäksi käyttäjä voi hakea säätietoja.

Sovelluksen aloitusnäkymä on Omat keräilykohteet -näkymä. Siinä näytetään käyttäjän luomat keräilykohteet kortteina, joissa on kohteen nimi ja siihen mennessä kerätty yhteismäärä. Käyttäjä voi poistaa kohteen painamalla roskakorikuvaketta kortin vasemmassa yläkulmassa.

Ylätyökalurivin pluspainikkeesta avautuu näkymä, jossa käyttäjä voi luoda uuden keräilykohteen. Kohteelle annetaan nimi ja kerätty määrä, valitaan yksiköksi litra tai kilo, sekä valitaan päivämäärä. Lisäksi käyttäjä voi lisätä muistiinpanoja. Sovellus vaatii vähintään nimen antamisen kohteelle. Kahdelle kohteelle ei voi antaa samaa nimeä. Mikäli muihin kenttiin ei syötetä tietoja, tulee määräksi 0.0, yksiköksi litra, päivämääräksi kyseinen päivä ja muistiinpanot jäävät tyhjäksi. Kun käyttäjä painaa Tallenna-painiketta kohteen tiedot tallentuvat laitteen muistiin SQLite-tietokantaan ja sovellus palaa Omat keräilykohteet -näkymään, jonne luotu kohde on lisätty. Peruuta painikkeesta sovellus palaa Omat keräilykohteet -näkymään tallentamatta kohdetta.
Painamalla kynäkuvaketta kortin oikeassa yläkulmassa, avautuu näkymä, jossa voi muokata keräilykohteen nimeä ja vaihtaa keräiltävän yksikön.

![kohdesivut](images/kohteet_sivut.png)

