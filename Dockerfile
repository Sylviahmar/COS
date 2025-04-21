# Use official Python image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy test script and requirements
COPY . .

# Install dependencies
RUN pip install --upgrade pip \
    && pip install selenium \
    && apt-get update && apt-get install -y wget unzip \
    && wget https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin/chromedriver \
    && chmod +x /usr/local/bin/chromedriver \
    && apt-get install -y chromium

# Set environment variable for Chrome
ENV CHROME_BIN=/usr/bin/chromium

# Run tests
CMD ["python", "test_survey_website.py"]
