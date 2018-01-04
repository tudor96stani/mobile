//import liraries
import React, { Component } from "react";
import { View, Text, StyleSheet,TextInput,TouchableOpacity,Alert } from "react-native";
import ApiClient from "../../Utils/ApiClient";
// create a component
class AddAuthor extends Component {
  static navigationOptions = {
    title: "Add author",
    headerStyle: { backgroundColor: "#2c3e50" },
    headerTitleStyle: { color: "white" }
  };

  constructor(props) {
    super(props);
    this.state = {
      firstName: "",
      lastName: ""
    };
  }

  save = async () => {
    var fn = this.state.firstName;
    var ln = this.state.lastName;
    var addResult = await ApiClient.addAuthor(fn, ln);
    if(addResult.Ok===true)
    {

    }
    else{
        Alert.alert("Crap");
    }
    this.props.navigation.state.params.onGoBack();
    this.props.navigation.goBack();
  };
  render() {
    return (
      <View style={styles.container}>
        <TextInput
          style={styles.input}
          autoCapitalize="none"
          onChangeText={fn => this.setState({ firstName: fn })}
          autoCorrect={false}
          keyboardType="default"
          returnKeyType="next"
          value={this.state.firstName}
          placeholder="First name"
          placeholderTextColor="rgba(225,225,225,0.7)"
        />
        <TextInput
          style={styles.input}
          autoCapitalize="none"
          onChangeText={ln => this.setState({ lastName: ln })}
          autoCorrect={false}
          keyboardType="default"
          returnKeyType="done"
          value={this.state.lastName}
          placeholder="Last name"
          placeholderTextColor="rgba(225,225,225,0.7)"
        />
        <TouchableOpacity style={styles.buttonContainer} onPress={this.save}>
          <Text style={styles.buttonText}>Add</Text>
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
export default AddAuthor;
