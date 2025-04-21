from selenium import webdriver
from selenium.webdriver.common.by import By
import time

# Set up driver (update path to chromedriver if needed)
driver = webdriver.Chrome()

# Base URL of your React app
base_url = "http://localhost:3000"

# 1. Test Home Page
def test_home_page():
    driver.get(base_url)
    time.sleep(2)
    # Verify the heading on the dashboard page
    assert "Welcome to FooDelicious" in driver.page_source
    print("Home page test passed")
# 2. Test Basic Info Page
def test_login_button():
    driver.get(base_url)
    time.sleep(2)
    # Check if the login button exists and is clickable
    login_button = driver.find_element(By.CLASS_NAME, "login_btn")
    assert login_button.is_displayed()  # Verify the button is visible
    assert login_button.is_enabled()  # Verify the button is clickable
    login_button.click()  # Click the login button
    time.sleep(2)
    # After clicking, we expect to be redirected to the signup page (you can adjust based on actual behavior)
    assert driver.current_url == "http://localhost:3000/signup"
    print("Login button test passed")
# 3. Test Survey Questions Page
def test_survey_questions_page():
    driver.get(base_url + "/survey")
    time.sleep(2)
    assert "Survey Questions" in driver.page_source
    print("Survey Questions page test passed")

# 4. Test Responses Page
def test_responses_page():
    driver.get(base_url + "/responses")
    time.sleep(2)
    assert "Your Responses" in driver.page_source
    print("Responses page test passed")

# 5. Test Thank You Page
def test_thank_you_page():
    driver.get(base_url + "/thank-you")
    time.sleep(2)
    assert "Thank you for participating" in driver.page_source
    print("Thank You page test passed")

# Run all tests
try:
    test_home_page()
    test_basic_info_page()
    test_survey_questions_page()
    test_responses_page()
    test_thank_you_page()
finally:
    driver.quit()
