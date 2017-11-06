//import liraries
import React, { Component } from "react";
import { View, Text, StyleSheet } from "react-native";

// create a component
class BookDetails extends Component {
  static navigationOptions = {
    title: "Details",
    headerStyle: { backgroundColor: "#2c3e50" },
    headerTitleStyle: { color: "white" }
  };
  constructor(props) {
    super(props);
  }
  render() {
    const { state } = this.props.navigation;
    var book = state.params ? state.params.book : "<undefined>";
    return (
      <View style={styles.container}>
        <Text style={styles.text}>{book.title}</Text>
        <Text style={styles.textLower}>by</Text>
        <Text style={styles.text}>
          {book.author.firstName} {book.author.lastName}
        </Text>
      </View>
    );
  }
}

// define your styles
const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#2c3e50"
  },
  text: {
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#2c3e50",
    color: "white",
    fontSize: 30
  },
  textLower: {
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#2c3e50",
    color: "white",
    fontSize: 20
  }
});

//make this component available to the app
export default BookDetails;
