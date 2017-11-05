import React from "react";
import { StyleSheet, Text, View } from "react-native";
import Login from "./src/Components/Login/Login";
import BookList from "./src/Components/BookList/BookList";
import { StackNavigator } from "react-navigation";

const Application = StackNavigator(
  {
    Login: { screen: Login },
    BookList: { screen: BookList }
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
