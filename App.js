import React from "react";
import { StyleSheet, Text, View, Alert } from "react-native";
import Login from "./src/Components/Login/Login";
import BookList from "./src/Components/BookList/BookList";
import { StackNavigator } from "react-navigation";
import Register from "./src/Components/Register/Register";
import BookDetails from "./src/Components/BookDetails/BookDetails";
import ApiClient from "./src/Components/Utils/ApiClient";

const Application = StackNavigator(
  {
    Login: { screen: Login },
    BookList: { screen: BookList },
    Register: { screen: Register },
    BookDetails: { screen: BookDetails }
  },
  {
    headerMode: "screen",
    header: null
  }
);

export default class App extends React.Component {
  render() {
    
    return <Application />;
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center"
  }
});
