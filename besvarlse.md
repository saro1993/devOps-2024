# DevOps-2024 - Prosjektinnlevering

## Oppgave 1: API og Repository Detaljer

### Repository URL
GitHub-repositoriet for prosjektet ligger tilgjengelig her: [GitHub Repository](<https://github.com/saro1993/devOps-2024>)

### API Endpoint Detaljer
- **API URL**: `https://92qcscyokg.execute-api.eu-west-1.amazonaws.com/Prod/image-generate/`
- **HTTP-metode**: POST
- **Headers**: `Content-Type: application/json`
- **Request Body (JSON-format)**:
  ```json
  {
    "prompt": "Skap et bilde basert på denne beskrivelsen vi sender inn: veldig morsomt 😊"
  }
  ```
- **Curl-kommando**:
  ```bash
  curl -X POST "https://92qcscyokg.execute-api.eu-west-1.amazonaws.com/Prod/image-generate/" \
       -H "Content-Type: application/json" \
       -d '{"prompt":"dog with cat"}'
  ```

## Oppgave 2: API og SQS-kø Konfigurasjon

### SQS Kø URL og Test
- **SQS-kø URL**: `https://sqs.eu-west-1.amazonaws.com/244530008913/image_processing_queue`
- **Send melding til køen**:
  ```bash
  aws sqs send-message --queue-url "https://sqs.eu-west-1.amazonaws.com/244530008913/image_processing_queue" --message-body "Test message"
  ```
- **Motta melding fra køen**:
  ```bash
  aws sqs receive-message --queue-url "https://sqs.eu-west-1.amazonaws.com/244530008913/image_processing_queue"
  ```

## Oppgave 3: Docker Konfigurasjon

### Dockerfile Beskrivelse
Dette Dockerfile er en multi-stage build:
1. **Build stage**
   - Basert på Maven 3.8.4 med OpenJDK 17.
   - Arbeidskatalog: `/app`
   - Kopier og bygg prosjektet med: `mvn clean package`
2. **Runtime stage**
   - Bruker `openjdk:17-jdk-slim` for å kjøre applikasjonen.
   - Kopier JAR-fil fra build til runtime miljø.
   - Miljøvariabel: `SQS_QUEUE_URL`
   - ENTRYPOINT for å starte applikasjonen.

### Tagging-strategi og Kjøring av Docker Image
- **Tagging-strategi**:
  - `latest`: Den nyeste versjonen av klienten.
  - `v1.0`, `v1.1`: Spesifikke versjoner for større oppdateringer.
- **Kjøre Docker-image**:
  ```bash
  docker run -e AWS_ACCESS_KEY_ID=xxx -e AWS_SECRET_ACCESS_KEY=yyy -e SQS_QUEUE_URL="https://sqs.eu-west-1.amazonaws.com/244530008913/image_processing_queue" sarosamall/sqs-client
  ```

## Oppgave 4: Metrisk og Overvåkning

### CloudWatch og SNS Varsling
- **CloudWatch Alarm**: Overvåker `ApproximateAgeOfOldestMessage`.
- **SNS-varsling**: Sender e-post til `sarosamall@yahoo.com` når alarmen utløses.
- **Testing**:
  Alarmen testes ved å øke køforsinkelsen og overvåke responsen via e-post.

# Oppgave 5: Serverless vs. Mikrotjenester

## Innledning
Når vi utvikler moderne applikasjoner, har vi ofte to populære valg: **serverless arkitektur** og **mikrotjenestearkitektur**. Disse to tilnærmingene har sine egne fordeler og ulemper.

- **Serverless** (f.eks. AWS Lambda) lar oss kjøre små funksjoner uten å tenke på servere. Alt vi trenger å gjøre er å skrive koden, og skyplattformen tar seg av resten.
- **Mikrotjenester** handler om å dele applikasjonen opp i flere små tjenester, ofte pakket som containere. Disse tjenestene kan håndteres uavhengig, men krever mer teknisk innsats.

I denne oppgaven ser vi nærmere på hvordan disse arkitekturene påvirker sentrale prinsipper innen **DevOps**: automatisering, overvåkning, skalerbarhet og eierskap.

---

## Automatisering og kontinuerlig levering (CI/CD)

### Serverless
- **Fordeler:**
  - Det er veldig enkelt å automatisere. Vi laster bare opp koden din, og plattformen sørger for at den blir distribuert.
  - CI/CD-pipelines er lettere å sette opp fordi hver funksjon er liten og håndterbar.
- **Ulemper:**
  - Har vi mange funksjoner, kan det bli mye å vedlikeholde. Hver enkelt pipeline må oppdateres ved endringer.

### Mikrotjenester
- **Fordeler:**
  - Gir oss full kontroll over distribusjonsprosessen. Hver tjeneste kan oppdateres på sine egne premisser.
- **Ulemper:**
  - Å sette opp CI/CD for mange tjenester krever avansert kompetanse og kan bli tidkrevende.
  - Verktøy som Docker og Kubernetes gjør jobben mulig, men øker kompleksiteten.

---

## Overvåkning

### Serverless
- **Fordeler:**
  - Plattformen har innebygde verktøy som AWS CloudWatch og AWS X-Ray for logging og sporing.
- **Ulemper:**
  - Loggene er spredt utover ulike tjenester, og det kan være vanskelig å få oversikt over hva som skjer når noe går galt.
  - Hvis flere funksjoner er involvert i en feil, tar det tid å finne årsaken.

### Mikrotjenester
- **Fordeler:**
  - Vi kan bruke kraftige overvåkingsverktøy som Prometheus og Grafana for å få full oversikt
  - Logging og sporing kan settes opp mellom tjenestene med verktøy som Elasticsearch og OpenTelemetry.
- **Ulemper:**
  - Vi må selv sette opp alt dette, noe som tar tid og krever teknisk ekspertise.

---

## Skalerbarhet og kostnadskontroll

### Serverless
- **Fordeler:**
  - Serverless skalerer automatisk når det er behov for det. Har du mange brukere, starter plattformen flere instanser uten at vi trenger å gjøre noe.
  - Kostnadene er basert på bruk – vi betaler bare for det du faktisk bruker.
- **Ulemper:**
  - Hvis belastningen er konstant høy, kan det bli dyrt over tid.

### Mikrotjenester
- **Fordeler:**
  - Vi har mer kontroll over ressursbruken, og kostnadene er ofte lettere å forutsi.
- **Ulemper:**
  - Skalerbarheten må håndteres manuelt, for eksempel ved å bruke Kubernetes autoscaler.

---

## Eierskap og ansvar

### Serverless
- **Fordeler:**
  - Mye av ansvaret tas av skyplattformen – Vi trenger ikke å bekymre oss for servervedlikehold.
  - Utviklere kan fokusere på å bygge applikasjonen i stedet for å tenke på drift.
- **Ulemper:**
  - Vi er avhengig av leverandøren (AWS, Azure osv.) for ytelse og stabilitet.

### Mikrotjenester
- **Fordeler:**
  - Teamet har full kontroll over hele systemet, fra infrastruktur til applikasjonens ytelse.
- **Ulemper:**
  - Krever mer teknisk kompetanse og ansvar. Teamet må selv sikre at alt fungerer som det skal.

---

## Konklusjon
**Serverless** er en god løsning for små team eller prosjekter med ujevn belastning. Det er lett å komme i gang, det skalerer automatisk, og det lar teamet fokusere på å skrive kode. Men det kan bli dyrt ved jevn høy belastning, og overvåkning kan bli krevende i større prosjekter.

**Mikrotjenester** passer bedre for store systemer med mange komponenter og jevn bruk. Denne arkitekturen gir oss mye kontroll, men krever også mer arbeid for oppsett, overvåkning og drift.

**Hva bør du velge?**
- Vil vi fokusere på utvikling og la leverandøren håndtere driften? **Velg serverless.**
- Vil vi ha full kontroll over infrastrukturen? **Velg mikrotjenester.**


### Kilder
- [Prometheus](https://prometheus.io/docs/introduction/overview/)
- [Grafana](https://grafana.com/docs/grafana-cloud/)
- [Kubernetes](https://kubernetes.io/docs/home/)
- [Elastic](https://www.elastic.co/docs)
- [OpenTelemetry](https://opentelemetry.io/docs/)
```