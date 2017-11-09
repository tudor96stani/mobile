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
  Alert,
  Picker
} from "react-native";
import Communications from 'react-native-communications';

import ApiClient from "../../Utils/ApiClient";
// create a component
class Register extends Component {
  static navigationOptions = {
    title: "Register",
    headerStyle: { backgroundColor: "#2c3e50" },
    headerTitleStyle: { color: "white" }
  };
  constructor(props) {
    super(props);
    this.state = {
      username: "",
      password: "",
      email: "",
      role: 1
    };
  }

  RegisterClick = () => {
    var roleName = this.state.role==='1'?'viewer':'owner'
    ApiClient.register(
      this.state.username,
      this.state.password,
      this.state.role
    ).then(result => {
      if (result === "OK") {
        Communications.email([this.state.email],null,null,'Welcome to the BookManagement Society','Welcome to the Book Management society! Your username is '+this.state.username);
        Alert.alert("Account successfully created ");
        
        this.props.navigation.goBack();
      } else {
        Alert.alert("ERROR: " + result);
        console.log(result);
      }
    });
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
          autoCapitalize="none"
          onChangeText={email => this.setState({ email })}
          autoCorrect={false}
          keyboardType="default"
          returnKeyType="next"
          placeholder="email"
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
        <Picker
          selectedValue={this.state.role}
          onValueChange={(itemValue, itemIndex) =>
            this.setState({ role: itemValue })}
        >
          <Picker.Item label="Viewer" value="1" />
          <Picker.Item label="Owner" value="2" />
        </Picker>

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
    flex: 1,
    paddingTop: 50,
    padding: 20,
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

//make this component available to the app
export default Register;
