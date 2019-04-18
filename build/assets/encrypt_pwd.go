package main
import (
  "fmt"
  "io/ioutil"
  passlib "gopkg.in/hlandau/passlib.v1"
)

var config_file = "secrets.json"

func check(e error) {
  if e != nil {
    panic(e)
  }
}

func getPwd() string {
  // Prompt the user to enter a password
  fmt.Println("Enter a password")
  // Variable to store the users input
  var pwd string
  // Read the users input
  _, err := fmt.Scan(&pwd)
  check(err)
  // Return the users input as a byte slice which will save us
  // from having to do this conversion later on
  return pwd
}

func hashAndSalt(pwd string) string {

  // Use GenerateFromPassword to hash & salt pwd.
  // MinCost is just an integer constant provided by the bcrypt
  // package along with DefaultCost & MaxCost.
  // The cost can be any value you want provided it isn't lower
  // than the MinCost (4)
  hash, err := passlib.Hash(pwd)
  check(err)
  // GenerateFromPassword returns a byte slice so we need to
  // convert the bytes to a string and return it
  return string(hash)
}

func writeToFile(hash string)  {
  file_output := fmt.Sprintf("{\"admin_password_hash\":\"%s\"}", hash)
  err := ioutil.WriteFile(config_file, []byte(file_output), 0400)
  check(err)
}

func main() {
  // Enter a password and generate a salted hash
  pwd := getPwd()
  hash := hashAndSalt(pwd)
  fmt.Println("Salted Hash", hash)
  writeToFile(hash)
}
