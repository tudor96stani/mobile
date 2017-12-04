import { AsyncStorage } from "react-native";
export const BASE_URL = "http://home-server.go.ro/MobileApi/api/v1/";
export const LOGIN_URL = "http://home-server.go.ro/MobileApi/token";
export const GET_BOOKS_URL = BASE_URL + "books/user/";
export const REGISTER_URL = BASE_URL + "users/register";
export const VERIFY_URL = BASE_URL + "users/verify";
export const AUTHORS_URL = BASE_URL + "authors";
export const UPDATE_BOOK_URL = BASE_URL + "books/update";
export const ADD_BOOK_URL = BASE_URL + "books/create";
export const DELETE_BOOK_URL = BASE_URL + "books/delete/";

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
      await ApiClient.login();
      return true;
    }
  }

  //login method used only to refresh the token
  static async login() {
    var username = await AsyncStorage.getItem("username");
    var passw = await AsyncStorage.getItem("password");
    await ApiClient.login(self.username, passw);
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

    var jsonRes = await response.json();
    var id = jsonRes.Id;
    var username = jsonRes.Username;
    var token = jsonRes.access_token;
    var role = jsonRes.role;

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
      var jsonRes = await response.json();
      var a = 4;
      return jsonRes;
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
      var jsonRes = await response.json();
      if (jsonRes.ok == true) {
        return "OK";
      } else {
        return jsonRes.message;
      }
    } else {
      return "ERROR";
    }
  }

  static fetchAuthors = async () => {
    var response = await fetch(AUTHORS_URL);
    if (response.status >= 200 && response.status < 300) {
      var jsonRes = response.json();
      return jsonRes;
    } else {
      return null;
    }
  };

  static addBook = async (title, authorid) => {
    var userid = await AsyncStorage.getItem("userid");
    var params = {
      title: title,
      authorId: authorid,
      userId: userid
    };
    var token = await AsyncStorage.getItem("token");
    var formBody = [];
    for (var property in params) {
      var encodedKey = encodeURIComponent(property);
      var encodedValue = encodeURIComponent(params[property]);
      formBody.push(encodedKey + "=" + encodedValue);
    }
    formBody = formBody.join("&");
    var headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      Authorization: "Bearer " + token
    };

    var response = await fetch(ADD_BOOK_URL, {
      method: "POST",
      headers: headers,
      body: formBody
    });

    if (response.status >= 200 && response.status < 300) {
      var jsonRes = await response.json();
      if (jsonRes.ok === true) {
        return { ok: true, res: jsonRes.book, message: jsonRes.message };
      } else {
        return { ok: false, res: null, message: jsonRes.message };
      }
    } else {
      console.log(response.status);
      return { ok: false, res: null, message: "Error" };
    }
  };

  static updateBook = async (bookid, title, authorid) => {
    var params = {
      Id: bookid,
      Title: title,
      AuthorId: authorid
    };
    var token = await AsyncStorage.getItem("token");

    var formBody = [];
    for (var property in params) {
      var encodedKey = encodeURIComponent(property);
      var encodedValue = encodeURIComponent(params[property]);
      formBody.push(encodedKey + "=" + encodedValue);
    }
    formBody = formBody.join("&");
    var headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      Authorization: "Bearer " + token
    };
    console.log(formBody);
    var response = await fetch(UPDATE_BOOK_URL, {
      method: "POST",
      headers: headers,
      body: formBody
    });
    console.log(response);
    if (response.status >= 200 && response.status < 300) {
      var jsonRes = await response.json();
      console.log(jsonRes);
      var a = 5;
      return { ok: true, res: jsonRes };
    } else {
      console.log(response.status);
      return { ok: false, res: null };
    }
  };

  static deleteBook = async id => {
    var token = await AsyncStorage.getItem("token");
    var headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      Authorization: "Bearer " + token
    };

    var response = await fetch(DELETE_BOOK_URL + id, {
      method: "POST",
      headers: headers
    });

    if (response.status >= 200 && response.status < 300) {
      var jsonRes = await response.json();
      if (jsonRes.ok === true) {
        return { ok: true };
      }
    }
    return { ok: false };
  };
}
