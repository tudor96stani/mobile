//import liraries
import React, { Component } from "react";
import {
  View,
  Text,
  StyleSheet,
  Button,
  FlatList,
  AsyncStorage,
  Alert,
  Icon,
  ListItem,
  TouchableOpacity
} from "react-native";
import * as URLS from "../../Utils/ApiClient";
import ApiClient from "../../Utils/ApiClient";
const LogoutText = "Log out";
// create a component
class BookList extends Component {
  static navigationOptions = {
    title: "Your books",
    headerStyle: { backgroundColor: "#2c3e50" },
    headerTitleStyle: { color: "white" }
  };
  constructor(props) {
    super(props);

    this.state = {
      userid: "",
      token: "",
      dataSource: [
        {
          title: "",
          author: {
            firstName: "",
            lastName: ""
          }
        }
      ]
    };
  }

  componentDidMount() {
    ApiClient.fetchBooks().then(books => {
      if (books != null) {
        this.setState({ dataSource: books });
      }
    });
  }

  selectItem(authid, fn) {
    Alert.alert(fn);
  }

  render() {
    const { navigate } = this.props.navigation;
    return (
      <View style={styles.container}>
        <FlatList
          data={this.state.dataSource}
          renderItem={({ item }) => (
            <TouchableOpacity
              style={styles.cell}
              onPress={() => navigate("BookDetails", { book: item })}
            >
              <Text style={styles.text}>{item.title}</Text>
              <Text style={styles.text}>
                {item.author.firstName} {item.author.lastName}
              </Text>
            </TouchableOpacity>
          )}
          keyExtractor={(item, index) => index}
        />
      </View>
    );
  }
}

// define your styles
const styles = StyleSheet.create({
  container: {
    flex: 1,
    //marginTop: 10,
    backgroundColor: "#2c3e50",
    //paddingTop: 10
  },
  rowContainer: {
    flex: 1,
    padding: 12,
    flexDirection: "row",
    alignItems: "center"
  },
  text: {
    marginLeft: 12,
    fontSize: 20
  },
  cell: {
    flex: 1,
    margin: 5,
    backgroundColor: "#95a5a6",
    height: 50
  }
});

//make this component available to the app
export default BookList;
