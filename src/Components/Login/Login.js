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
import ApiClient from "../../Utils/ApiClient";
import { NetInfo } from "react-native";
import * as Constants from "../../Utils/ApiClient";
import * as StorageKeys from "../../Utils/Constants";
import { AsycnStorageKeys } from "../../Utils/Constants";
// create a component
export default class Login extends Component {
  static navigationOptions = {
    header: null
  };
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
    var type1 = await NetInfo.getConnectionInfo();

    var value = await AsyncStorage.getItem("userid");
    if (value != null) {
      var type = await NetInfo.getConnectionInfo();
      var role = await AsyncStorage.getItem("role");
      if (type.type === "none") {
        if (role === "1") {
          this.props.navigation.navigate("ViewerBookList");
        } else {
          this.props.navigation.navigate("BookList");
        }
      } else {
        ApiClient.refresh().then(x => {
          if (role === "1") {
            this.props.navigation.navigate("ViewerBookList");
          } else {
            this.props.navigation.navigate("BookList");
          }
        });
      }
    }
  };

  Login = async () => {
    var result = await ApiClient.login(this.state.username, this.state.password);
    if (result === "OK") 
    {
      var role = await AsyncStorage.getItem("role");
      console.log(role);
      if(role==="1")
      {
        this.props.navigation.navigate("ViewerBookList");
      }else{
      this.props.navigation.navigate("BookList");
      }
    }
    else {
        //Alert.alert("There was ane error");
      }
  };

  SaveInfo = async (username, password, token, id, role) => {
    await AsyncStorage.setItem("userid", String(id));
    await AsyncStorage.setItem("username", String(username));
    await AsyncStorage.setItem("token", String(token));
    await AsyncStorage.setItem("password", String(password));
    await AsyncStorage.setItem("role", String(role));
  };

  RegisterClick = () => {
    this.props.navigation.navigate("Register");
  };

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.labelText}>LOGIN</Text>
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
        <TouchableOpacity
          style={styles.buttonContainer}
          onPress={this.RegisterClick}
        >
          <Text style={styles.buttonText}>REGISTER</Text>
        </TouchableOpacity>
      </View>
    );
  }
}

// define your styles
const styles = StyleSheet.create({
  container: {
    paddingTop: 150,
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
    marginTop: 30
  },
  buttonText: {
    color: "#fff",
    textAlign: "center",
    fontWeight: "700"
  },
  labelText: {
    color: "white",
    textAlign: "center",
    fontWeight: "600",
    paddingBottom: 50,
    fontSize: 40
  }
});
