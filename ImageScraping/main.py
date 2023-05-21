import undetected_chromedriver as uc
from selenium import webdriver
from selenium.webdriver.common.by import By

import urllib
import time

# Configure WebDriver
driver_path = "/Users/a970/Downloads/chromedriver/chromedriver"  # Replace with the actual path to the downloaded driver

# options = webdriver.ChromeOptions()
# options.add_argument('proxy-server=106.122.8.54:3128')
# chrome_options.add_argument('--headless')
# chrome_options.add_argument('--no-sandbox')
# chrome_options.add_argument('--disable-dev-shm-usage')
# options.add_argument('--user-data-dir=/Users/a970/Library/Application Support/Google/Chrome/Default')
# chrome_options.add_argument('--disable-blink-features=AutomationControlled')
# driver = uc.Chrome(options=options)
# driver.maximize_window()

car_list = [
    "toyota+RAV4",
    "toyota+86",
    "toyota+Sienna",
    "toyota+Camry",
    "toyota+C-HR",
    "toyota+Corolla+sedan",
    "toyota+4Runner",
    "toyota+Venza"
]

views = {
    'stock+photos' : 20,
    "front+view" : 20,
    "side+profile" : 20,
    "back+angle+view" : 20,
    "on+the+road" : 20,
    "tailight+view+photoshoot" : 20,
    "headlight+view+photoshoot" : 20,
    "modifications+photoshoot" : 20
    }
    

# Launch Browser and Open the URL
counter = 0
for car_model in car_list:
    for angle, numOfPics in views.items():
        options = webdriver.ChromeOptions()
        options.add_argument('--user-data-dir=/Users/a970/Library/Application Support/Google/Chrome/Default')
        driver = uc.Chrome(options=options)
        driver.minimize_window()

        # Create url variable containing the webpage for a Google image search.
        # url = "https://www.google.com/search?q={s}&tbm=isch&tbs=sur%3Afc&hl=en&ved=0CAIQpwVqFwoTCKCa1c6s4-oCFQAAAAAdAAAAABAC&biw=1251&bih=568"
        url = str("https://www.google.com/search?q={0}+{1}&hl=en&tbm=isch&sxsrf=APwXEdeMCCcn15mo1obWv-xVcr_tpnFYQg%3A1684476865544&source=hp&biw=1737&bih=1032&ei=wRNnZNX-HtX4kPIP9umT2AY&iflsig=AOEireoAAAAAZGch0VXQnHgSIAIKBwcg5h0gf-nJjQvD&oq=toyota+supr&gs_lcp=CgNpbWcQAxgAMgQIIxAnMgQIIxAnMggIABCABBCxAzIICAAQgAQQsQMyBQgAEIAEMggIABCABBCxAzIICAAQgAQQsQMyCAgAEIAEELEDMggIABCABBCxAzIICAAQgAQQsQM6BwgjEOoCECc6CAgAELEDEIMBOgQIABADOgkIABAYEIAEEApQlglY7SNgpSxoB3AAeAGAAZIBiAHkDJIBBDEwLjeYAQCgAQGqAQtnd3Mtd2l6LWltZ7ABCg&sclient=img".format(car_model, angle))
        # Launch the browser and open the given url in your webdriver.
        # search_query = "Toyota Supra"

        #[general], front view, rear view, side profile, back angle view, on the road, tail-lights, headlights
        driver.get(url)


        # The execute script function will scroll down the body of the web page and load the images.
        driver.execute_script("window.scrollTo(0,document.body.scrollHeight);")
        time.sleep(5)

        # Review the Web Page’s HTML Structure

        # We need to understand the structure and contents of the HTML tags and find an attribute that is unique only to images.
        img_results = driver.find_elements(By.XPATH, "//img[contains(@class, 'Q4LuWd')]")

        # Extract the image URLs
        image_urls = []
        for img in img_results:
            image_urls.append(img.get_attribute('src'))

        # Specify the folder path to store the downloaded images
        folder_path = '/Volumes/Intel500G/CarImageDB/'

        modifiedName = car_model.replace("+", " ")

        for i in range(numOfPics):
            # urllib.request.urlretrieve(str(image_urls[i]), folder_path + "{0}{1}.jpg".format(search_query, i))
            urllib.request.urlretrieve(str(image_urls[i]), folder_path + "{0} {1}.jpg".format(modifiedName, i + counter))


        driver.quit()
        time.sleep(3)

    counter += numOfPics

        




