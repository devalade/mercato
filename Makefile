.PHONY: build clean run server-start server-stop deploy undeploy test db-start db-stop help

# Configuration
GLASSFISH_VERSION=7.1.0
GLASSFISH_DIR=$(HOME)/.local/share/glassfish
GLASSFISH_URL=https://github.com/eclipse-ee4j/glassfish/releases/download/$(GLASSFISH_VERSION)/glassfish-$(GLASSFISH_VERSION).zip
APP_NAME=mercato
DB_NAME=mercato
DB_USER=mercato
DB_PASSWORD=mercato

# Maven
MAVEN_OPTS=-Xmx512m

help:
	@echo "Mercato - Jakarta EE 10 Application"
	@echo ""
	@echo "Available commands:"
	@echo "  make build         - Compile and package the application (WAR)"
	@echo "  make clean        - Clean build artifacts"
	@echo "  make db-start     - Start PostgreSQL database (Docker)"
	@echo "  make db-stop      - Stop PostgreSQL database"
	@echo "  make server-start - Download and start GlassFish 7"
	@echo "  make server-stop  - Stop GlassFish server"
	@echo "  make deploy       - Deploy application to GlassFish"
	@echo "  make undeploy     - Undeploy application from GlassFish"
	@echo "  make run          - Start DB, deploy and run the app"
	@echo "  make test         - Run unit tests"
	@echo ""

build:
	@echo "Building application..."
	mvn clean package -DskipTests

clean:
	@echo "Cleaning build artifacts..."
	mvn clean
	rm -rf target

test:
	mvn test

db-start:
	@echo "Starting PostgreSQL database..."
	@if ! docker ps | grep -q mercato-db; then \
		if docker ps | grep -q postgres18; then \
			echo "Using existing PostgreSQL on port 5432"; \
		else \
			docker run -d \
				--name mercato-db \
				-e POSTGRES_DB=$(DB_NAME) \
				-e POSTGRES_USER=$(DB_USER) \
				-e POSTGRES_PASSWORD=$(DB_PASSWORD) \
				-p 5432:5432 \
				postgres:16; \
			echo "Database started on port 5432"; \
		fi \
	else \
		echo "Database already running"; \
	fi

db-stop:
	@echo "Stopping PostgreSQL database..."
	@if docker ps | grep -q mercato-db; then \
		docker stop mercato-db && docker rm mercato-db; \
		echo "Database stopped"; \
	else \
		echo "Database not running"; \
	fi

$(GLASSFISH_DIR)/glassfish7:
	@echo "Downloading GlassFish 7..."
	@mkdir -p $(GLASSFISH_DIR)
	@curl -L -o /tmp/glassfish.zip $(GLASSFISH_URL)
	@unzip -q /tmp/glassfish.zip -d $(GLASSFISH_DIR)
	@mv $(GLASSFISH_DIR)/glassfish7 $(GLASSFISH_DIR)/glassfish7-temp
	@mv $(GLASSFISH_DIR)/glassfish7-temp $(GLASSFISH_DIR)/glassfish7
	@rm /tmp/glassfish.zip
	@echo "GlassFish 7 downloaded"

server-start: $(GLASSFISH_DIR)/glassfish7
	@echo "Starting GlassFish 7..."
	@$(GLASSFISH_DIR)/glassfish7/bin/asadmin start-domain domain1
	@echo "GlassFish started on http://localhost:8080"

server-stop:
	@echo "Stopping GlassFish 7..."
	@$(GLASSFISH_DIR)/glassfish7/bin/asadmin stop-domain domain1 2>/dev/null || echo "GlassFish not running"

server-status:
	@$(GLASSFISH_DIR)/glassfish7/bin/asadmin list-applications 2>/dev/null || echo "GlassFish not running"

deploy: build
	@echo "Deploying application to GlassFish..."
	@$(GLASSFISH_DIR)/glassfish7/bin/asadmin deploy --contextroot / target/$(APP_NAME).war

deploy-force: build
	@echo "Force deploying application to GlassFish..."
	@$(GLASSFISH_DIR)/glassfish7/bin/asadmin undeploy $(APP_NAME) 2>/dev/null || true
	@$(GLASSFISH_DIR)/glassfish7/bin/asadmin deploy --contextroot / target/$(APP_NAME).war

undeploy:
	@echo "Undeploying application..."
	@$(GLASSFISH_DIR)/glassfish7/bin/asadmin undeploy $(APP_NAME) 2>/dev/null || echo "Application not deployed"

run:
	@echo "Starting the application..."
	@$(GLASSFISH_DIR)/glassfish7/bin/asadmin start-domain domain1 2>/dev/null || true
	@$(GLASSFISH_DIR)/glassfish7/bin/asadmin create-jdbc-connection-pool \
		--restype javax.sql.DataSource \
		--datasourceclassname org.postgresql.ds.PGSimpleDataSource \
		--property "user=$(DB_USER):password=$(DB_PASSWORD):serverName=localhost:portNumber=5432:databaseName=$(DB_NAME)" \
		jdbc/mercato-pool || true
	@$(GLASSFISH_DIR)/glassfish7/bin/asadmin create-jdbc-resource \
		--connectionpoolid jdbc/mercato-pool \
		jdbc/mercato || true
	@$(GLASSFISH_DIR)/glassfish7/bin/asadmin deploy --contextroot / target/$(APP_NAME).war
	@echo ""
	@echo "Application deployed!"
	@echo "Access the app at: http://localhost:8080/"
	@echo "GlassFish Admin Console: http://localhost:4848/"
