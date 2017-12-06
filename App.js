import React from "react";
import { StyleSheet, Text, View, Alert } from "react-native";
import Login from "./src/Components/Login/Login";
import BookList from "./src/Components/BookList/BookList";
import { StackNavigator } from "react-navigation";
import Register from "./src/Components/Register/Register";
import BookDetails from "./src/Components/BookDetails/BookDetails";
import ApiClient from "./src/Utils/ApiClient";
import BookEdit from "./src/Components/BookEdit/BookEdit";
import AddBook from './src/Components/AddBook/AddBook';
import Chart from './src/Components/Chart/Chart';
const Application = StackNavigator(
  {
    Login: { screen: Login },
    BookList: { screen: BookList },
    Register: { screen: Register },
    BookDetails: { screen: BookDetails },
    BookEdit: { screen: BookEdit },
    AddBook:{screen:AddBook},
    Chart:{screen:Chart}
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
