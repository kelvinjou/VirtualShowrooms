from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
import urllib
import time

# Configure WebDriver
driver_path = "/Users/a970/Downloads/chromedriver/chromedriver"  # Replace with the actual path to the downloaded driver

chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
driver = webdriver.Chrome('chromedriver', chrome_options=chrome_options)

# Launch Browser and Open the URL

# Create url variable containing the webpage for a Google image search.
# url = "https://www.google.com/search?q={s}&tbm=isch&tbs=sur%3Afc&hl=en&ved=0CAIQpwVqFwoTCKCa1c6s4-oCFQAAAAAdAAAAABAC&biw=1251&bih=568"
url = "https://www.google.com/search?q=toyota+tacoma+offroading&hl=en&tbm=isch&sxsrf=APwXEdeMCCcn15mo1obWv-xVcr_tpnFYQg%3A1684476865544&source=hp&biw=1737&bih=1032&ei=wRNnZNX-HtX4kPIP9umT2AY&iflsig=AOEireoAAAAAZGch0VXQnHgSIAIKBwcg5h0gf-nJjQvD&oq=toyota+supr&gs_lcp=CgNpbWcQAxgAMgQIIxAnMgQIIxAnMggIABCABBCxAzIICAAQgAQQsQMyBQgAEIAEMggIABCABBCxAzIICAAQgAQQsQMyCAgAEIAEELEDMggIABCABBCxAzIICAAQgAQQsQM6BwgjEOoCECc6CAgAELEDEIMBOgQIABADOgkIABAYEIAEEApQlglY7SNgpSxoB3AAeAGAAZIBiAHkDJIBBDEwLjeYAQCgAQGqAQtnd3Mtd2l6LWltZ7ABCg&sclient=img"
# Launch the browser and open the given url in your webdriver.
# search_query = "Toyota Supra"

#[general], front view, rear view, side profile, back angle view, on the road, daily driver
driver.get(url)

# Load the Images

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

# Download the images
for i in range(20):
    # urllib.request.urlretrieve(str(image_urls[i]), folder_path + "{0}{1}.jpg".format(search_query, i))
    urllib.request.urlretrieve(str(image_urls[i]), folder_path + "Toyota Tacoma {0}.jpg".format(i + 112))


driver.quit()
