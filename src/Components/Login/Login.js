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
import ApiClient from '../../Utils/ApiClient'

import * as Constants from "../../Utils/ApiClient";
import * as StorageKeys from "../../Utils/Constants";
// create a component
export default class Login extends Component {
  static navigationOptions = {
    header:null
  }
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
    //verify if the user already logged in
    var value = await AsyncStorage.getItem('userid');
    if (value != null) {
      ApiClient.refresh().then(x => {
        this.props.navigation.navigate("BookList");
    });
      
    }
  };

  Login = () => {
    // var params = {
    //   grant_type: "password",
    //   username: this.state.username,
    //   password: this.state.password
    // };
    // var formData = new FormData();

    // for (var k in params) {
    //   formData.append(k, params[k]);
    // }

    // var formBody = [];
    // for (var property in params) {
    //   var encodedKey = encodeURIComponent(property);
    //   var encodedValue = encodeURIComponent(params[property]);
    //   formBody.push(encodedKey + "=" + encodedValue);
    // }
    // formBody = formBody.join("&");
    // var headers = {
    //   "Content-Type": "application/x-www-form-urlencoded"
    // };
    // var request = {
    //   method: "POST",
    //   headers: headers,
    //   body: formBody
    // };
    // console.log(formBody);
    // fetch(Constants.LOGIN_URL, request)
    //   .then(response => {
    //     if (response.status >= 200 && response.status < 300) {
    //       console.log("response status code == 200");
    //       return response;
    //     } else if (response.status === 401) {
    //       let error = new Error("Incorrect username or password");
    //       error.message = "Incorrect username or password";
    //       error.response = response;
    //       throw error;
    //     } else {
    //       let error = new Error(response.statusText);
    //       error.message = "Error";
    //       let code = response.status;
    //       console.log("Status :" + code);
    //       error.response = response;
    //       throw error;
    //     }
    //   })
    //   .then(response => response.json())
    //   .then(res => {
    //     var id = res.Id;
    //     var username = res.Username;
    //     var token = res.access_token;
    //     var role = res.role;
    //     this.SaveInfo(username, this.state.password, token, id,role);
    //     this.props.navigation.navigate("BookList");
    //   })
    //   .catch(e => {
    //     Alert.alert(e.message);
    //     console.log(e.message);
    //   })
    //   .done();
    ApiClient.login(this.state.username,this.state.password)
    .then(result =>{
      if (result === "OK")
        this.props.navigation.navigate("BookList");
      else{
        //Alert.alert("There was ane error");
        console.log("Cacat","Cacat");
      }
    });
  };

  SaveInfo = async (username, password, token, id,role) => {
    await AsyncStorage.setItem("userid", String(id));
    await AsyncStorage.setItem("username", String(username));
    await AsyncStorage.setItem("token", String(token));
    await AsyncStorage.setItem("password", String(password));
    await AsyncStorage.setItem("role", String(role));
  };

  RegisterClick = () =>{
    this.props.navigation.navigate("Register");
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.labelText}>
            LOGIN 
        </Text>
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
        <TouchableOpacity style={styles.buttonContainer} onPress={this.RegisterClick}>
          <Text style={styles.buttonText}>REGISTER</Text>
        </TouchableOpacity>
      </View>
    );
  }
}

// define your styles
const styles = StyleSheet.create({
  container: {
    paddingTop:150,
    padding: 20,
    flex: 1,
    backgroundColor: "#2c3e50"
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
    paddingVertical: 15,
    marginTop:30
  },
  buttonText: {
    color: "#fff",
    textAlign: "center",
    fontWeight: "700"
  },
  labelText:{
    color:'white',
    textAlign:'center',
    fontWeight:'600',
    paddingBottom:50,
    fontSize:40
  }
});
