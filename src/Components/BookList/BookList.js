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

import Swipeout from "react-native-swipeout";
const LogoutText = "Log out";
// create a component
class BookList extends Component {
  static navigationOptions = ({ navigation }) => {
    const { params = {} } = navigation.state;
    return {
      title: "Your books",
      headerStyle: { backgroundColor: "#2c3e50" },
      headerTitleStyle: { color: "white" },
      //headerRight: <Button title="+" onPress={()=>{console.log("Pula mea");}}/>
      headerRight: <Button title="+" onPress={() => params.handleAdd()} />
    };
  };

  addBook = () => {
    console.log("going to add book");
    this.props.navigation.navigate("AddBook", null);
  };
  constructor(props) {
    super(props);

    this.state = {
      refreshing: false,
      userid: "",
      token: "",
      dataSource: [
        {
          id: "",
          title: "",
          author: {
            firstName: "",
            lastName: ""
          }
        }
      ],
      activeRowId: null
    };
  }

  componentDidMount() {
    this.props.navigation.setParams({ handleAdd: this.addBook });
    ApiClient.fetchBooks().then(books => {
      if (books != null) {
        this.setState({ dataSource: books });
      }
    });
  }

  remove(id) {
    this.setState({
      dataSource: this.state.dataSource.filter((elem, i) => elem.id !== id)
    });
  }

  selectItem(authid, fn) {
    Alert.alert(fn);
  }

  refresh = () => {
    this.state.refreshing = true;
    this.componentDidMount();
    this.state.refreshing = false;
  };

  render() {
    const { navigate } = this.props.navigation;

    return (
      <View style={styles.container}>
        <FlatList
          data={this.state.dataSource}
          renderItem={({ item }) => (
            <TouchableOpacity
              style={styles.cell}
              onPress={() =>
                navigate("BookDetails", {
                  book: item,
                  onGoBack: id => this.remove(id)
                })}
            >
              <Text style={styles.text}>{item.title}</Text>
              <Text style={styles.text}>
                {item.author.firstName} {item.author.lastName}
              </Text>
            </TouchableOpacity>
          )}
          refreshing={this.state.refreshing}
          onRefresh={this.refresh}
          keyExtractor={(item, index) => item.id}
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
    backgroundColor: "#2c3e50"
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
