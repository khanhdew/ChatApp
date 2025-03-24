packages:
	make cleans
	@echo "Building the project..."
	@echo "Building the project: eurekaserver"
	mvn package -DskipTests -f ./eureka_server/pom.xml
	@echo "Building the project: apigateway"
	mvn package -DskipTests -f ./apigateway/pom.xml
	@echo "Building the project: message-service"
	mvn package -DskipTests -f ./messageservice/pom.xml
	@echo "Building the project: notification-service"
	mvn package -DskipTests -f ./notificationservice/pom.xml
	@echo "All projects built successfully"

cleans:
	@echo "Cleaning the project..."
	mvn clean -f ./apigateway/pom.xml
	mvn clean -f ./messageservice/pom.xml
	mvn clean -f ./notificationservice/pom.xml
	mvn clean -f ./eureka_server/pom.xml
	@echo "Project cleaned"

build_images:
	@echo "Packaging the project..."
	make packages
	@echo "Building the image..."
	@echo "Building the image: apigateway messageservice notificationservice"
	docker build -t khanhdew/apigateway ./apigateway
	docker build -t khanhdew/message-service ./messageservice
	docker build -t khanhdew/notification-service ./notificationservice
	docker build -t khanhdew/eureka-server ./eureka_server

package:
	@echo "Packaging the project..."
	@if [ "$(service)" = "apigateway" ]; then \
  		make clean service=apigateway; \
		mvn package -DskipTests -f ./apigateway/pom.xml; \
	elif [ "$(service)" = "message-service" ]; then \
	  	make clean service=message-service; \
		mvn package -DskipTests -f ./messageservice/pom.xml; \
	elif [ "$(service)" = "notification-service" ]; then \
	  	make clean service=notification-service; \
		mvn package -DskipTests -f ./notificationservice/pom.xml; \
	elif [ "$(service)" = "eureka-server" ]; then \
	  	make clean service=eureka-server; \
		mvn package -DskipTests -f ./eureka_server/pom.xml; \
	else \
		echo "Unknown service: $(service)"; \
	fi

clean:
	@echo "Cleaning the project..."
	@if [ "$(service)" = "apigateway" ]; then \
		mvn clean -f ./apigateway/pom.xml; \
	elif [ "$(service)" = "message-service" ]; then \
		mvn clean -f ./messageservice/pom.xml; \
	elif [ "$(service)" = "notification-service" ]; then \
		mvn clean -f ./notificationservice/pom.xml; \
	elif [ "$(service)" = "eureka-server" ]; then \
		mvn clean -f ./eureka_server/pom.xml; \
	else \
		echo "Unknown service: $(service)"; \
	fi

build_image:
	@echo "Building the image..."
	@if [ "$(service)" = "apigateway" ]; then \
  		make package service=apigateway; \
		docker build -t khanhdew/apigateway ./apigateway; \
	elif [ "$(service)" = "message-service" ]; then \
	  	make package service=message-service; \
		docker build -t khanhdew/message-service ./messageservice; \
	elif [ "$(service)" = "notification-service" ]; then \
	  	make package service=notification-service; \
		docker build -t khanhdew/notification-service ./notificationservice; \
	elif [ "$(service)" = "eureka-server" ]; then \
	  	make package service=eureka-server; \
		docker build -t khanhdew/eureka-server ./eureka_server; \
	else \
		echo "Unknown service: $(service)"; \
	fi

docker_up:
	@echo "Running Docker Compose dev"
	docker compose up -d
	@echo "Docker Compose running"

docker_down:
	@echo "Stopping Docker Compose"
	docker compose down
	@echo "Docker Compose stopped"

docker_push:
	@echo "Pushing the image..."
	@echo "Pushing the image: apigateway messageservice notificationservice"
	docker push khanhdew/apigateway
	docker push khanhdew/message-service
	docker push khanhdew/notification-service
	docker push khanhdew/eureka-server