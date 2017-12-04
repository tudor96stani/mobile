//import liraries
import React, { Component } from "react";
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  AsyncStorage
} from "react-native";
import ApiClient from "../../Utils/ApiClient";
// create a component
class BookDetails extends Component {
  static navigationOptions = {
    title: "Details",
    headerStyle: { backgroundColor: "#2c3e50" },
    headerTitleStyle: { color: "white" },
    rightButtons: [
      {
        title: "Edit", // for a textual button, provide the button title (label)
        id: "edit" // id for this button, given in onNavigatorEvent(event) to help understand which button was clicked
      }
    ]
  };
  constructor(props) {
    super(props);
    const { state } = this.props.navigation;
    const { navigate } = this.props.navigation;
    var book = state.params ? state.params.book : "<undefined>";
    this.state = {
      title: book.title,
      author: book.author.firstName + " " + book.author.lastName
    };
  }
  render() {
    const { state } = this.props.navigation;
    const { navigate } = this.props.navigation;
    var book = state.params ? state.params.book : "<undefined>";
    return (
      <View style={styles.container}>
        <Text style={styles.text}>{this.state.title}</Text>
        <Text style={styles.textLower}>by</Text>
        <Text style={styles.text}>{this.state.author}</Text>
        <TouchableOpacity
          style={styles.button}
          onPress={() =>
            navigate("BookEdit", {
              book: book,
              onGoBack: () => this.refresh()
            })}
        >
          <Text style={styles.textBtn}>Edit this book</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.buttonDelete}
          onPress={
            ()=>{
              //delete book
              ApiClient.deleteBook(book.id);
              
              this.props.navigation.state.params.onGoBack(book.id);
              this.props.navigation.goBack();
            }
          }
        >
          <Text style={styles.textBtn}>Delete</Text>
        </TouchableOpacity>
      </View>
    );
  }

  async refresh() {
    var newtitle = await AsyncStorage.getItem("newtitle");
    var newauthor = await AsyncStorage.getItem("newauthor");
    this.setState({ title: newtitle });
    this.setState({ author: newauthor });
    
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
  },
  button: {
    backgroundColor: "#2980b6",
    paddingVertical: 15,
    marginTop: 30
  },
  buttonDelete:{
    backgroundColor:"red",
    paddingVertical: 15,
    marginTop: 30
  },
  textBtn: {
    color: "#fff",
    textAlign: "center",
    fontWeight: "700"
  }
});

//make this component available to the app
export default BookDetails;
