import { AsyncStorage } from "react-native";
export const BASE_URL = "http://home-server.go.ro/MobileApi/api/v1/";
export const LOGIN_URL = "http://home-server.go.ro/MobileApi/token";
export const GET_BOOKS_URL = BASE_URL + "books/user/";
export const REGISTER_URL = BASE_URL + "users/register";
export const VERIFY_URL = BASE_URL + "users/verify";

export default class ApiClient {
  static username = "";
  static token = "";
  static async refresh() {
    var t = await AsyncStorage.getItem("token");
    const headers = {
      Authorization: "Bearer " + t
    };
    var response = await fetch(VERIFY_URL, {
      method: "GET",
      headers: headers
    });
    if (response.status >= 200 && response.status < 300) return true;
    else {
      await login();
      return true;
    }
  }

  //login method used only to refresh the token
  static async login() {
    var username = await AsyncStorage.getItem("username");
    var passw = await AsyncStorage.getItem("password");
    login(self.username, passw);
  }

  //complete login method
  static async login(username, password) {
    var params = {
      grant_type: "password",
      username: username,
      password: password
    };
    var formBody = [];
    for (var property in params) {
      var encodedKey = encodeURIComponent(property);
      var encodedValue = encodeURIComponent(params[property]);
      formBody.push(encodedKey + "=" + encodedValue);
    }
    formBody = formBody.join("&");
    var headers = {
      "Content-Type": "application/x-www-form-urlencoded"
    };
    var request = {
      method: "POST",
      headers: headers,
      body: formBody
    };
    var response = await fetch(LOGIN_URL, request);

    if (response.status >= 200 && response.status < 300) {
      console.log("response status code == 200");
    } else if (response.status === 401) {
      return "Username or password not correct";
    } else {
      return "ERROR";
    }

    var res = await response.json();
    var id = res.Id;
    var username = res.Username;
    var token = res.access_token;
    var role = res.role;
    //SaveInfo(username, password, token, id, role);
    await AsyncStorage.setItem("userid", String(id));
    await AsyncStorage.setItem("username", String(username));
    await AsyncStorage.setItem("token", String(token));
    await AsyncStorage.setItem("password", String(password));
    await AsyncStorage.setItem("role", String(role));
    return "OK";
  }

  static async fetchBooks() {
    var userid = await AsyncStorage.getItem("userid");
    var token = await AsyncStorage.getItem("token");
    const headers = {
      Authorization: "Bearer " + token
    };
    const url = GET_BOOKS_URL + userid;

    var response = await fetch(url, {
      method: "GET",
      headers: headers
    });

    if (response.status >= 200 && response.status < 300) {
      var res = await response.json();
      var a = 4;
      return res;
    } else {
      return null;
    }
  }

  static async register(username, password, role) {
    
    var params = {
      username: username,
      password: password,
      role: role
    };
    var formBody = [];
    for (var property in params) {
      var encodedKey = encodeURIComponent(property);
      var encodedValue = encodeURIComponent(params[property]);
      formBody.push(encodedKey + "=" + encodedValue);
    }
    formBody = formBody.join("&");
    var headers = {
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var response = await fetch(REGISTER_URL, {
      method: "POST",
      headers: headers,
      body: formBody
    });

    if (response.status >= 200 && response.status < 300) {
        var res = await response.json();
        if (res.ok==true){
            return "OK";
        }
        else{
            return res.message;
        }
    } else {
      return "ERROR";
    }

    

    
  }
}
