//import liraries
import React, { Component } from "react";
import {
  View,
  Text,
  StyleSheet,
  TextInput,
  TouchableOpacity,
  Button,
  AsyncStorage,
  Alert
} from "react-native";
import * as Constants from "../Utils/ApiClient";
import * as StorageKeys from '../Utils/Constants';
// create a component
export default class LoginForm extends Component {
  constructor(props) {
    super(props);
    this.state = {
      username: "",
      password: ""
    };
  }

  componentDidMount() {
    this._loadInitialState().done();
  }

  _loadInitialState = async () => {
    var value = await AsyncStorage.getItem(StorageKeys.UserId);
    if (value != null) {
      this.props.navigation.navigate("Profile");
    }
  };

  Login = () => {
    var params = {
      grant_type: "password",
      username: "tudor.stanila",
      password: "Parola1."
    };
    var formData = new FormData();

    for (var k in params) {
      formData.append(k, params[k]);
    }

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
    console.log(formBody);
    fetch(Constants.LOGIN_URL, request)
      .then((response) => {
        if (response.status >= 200 && response.status < 300) {
            console.log("response status code == 200");
          return response;
        } else {
          let error = new Error(response.statusText);
          let code = response.status;
          console.log("Status :"+ code);
          error.response = response;
          console.log(error);
        }
      })
      .then(response => response.json())
      .then(res => {
            AsyncStorage.setItem(StorageKeys.UserId,res.id);
            AsyncStorage.setItem(StorageKeys.Username,res.Username);
            AsyncStorage.setItem(StorageKeys.AccessToken,res.access_token);
            AsyncStorage.setItem(StorageKeys.Role,res.Role);
            this.props.navigation.navigate('BookList');
      })
      .done();
  };

  render() {
    return (
      <View style={styles.container}>
        <TextInput
          style={styles.input}
          autoCapitalize="none"
          onChangeText={username => this.setState({ username })}
          onSubmitEditing={() => this.passwordInput.focus()}
          autoCorrect={false}
          keyboardType="default"
          returnKeyType="next"
          placeholder="username"
          placeholderTextColor="rgba(225,225,225,0.7)"
        />

        <TextInput
          style={styles.input}
          returnKeyType="go"
          ref={input => (this.passwordInput = input)}
          onChangeText={password => this.setState({ password })}
          placeholder="Password"
          placeholderTextColor="rgba(225,225,225,0.7)"
          secureTextEntry
        />

        <TouchableOpacity style={styles.buttonContainer} onPress={this.Login}>
          <Text style={styles.buttonText}>LOGIN</Text>
        </TouchableOpacity>
      </View>
    );
  }
}

// define your styles
const styles = StyleSheet.create({
  container: {
    padding: 20
  },
  input: {
    height: 40,
    backgroundColor: "rgba(225,225,225,0.2)",
    marginBottom: 5,
    padding: 10,
    color: "#fff"
  },
  buttonContainer: {
    backgroundColor: "#2980b6",
    paddingVertical: 15
  },
  buttonText: {
    color: "#fff",
    textAlign: "center",
    fontWeight: "700"
  }
});
