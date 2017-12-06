//import liraries
import React, { Component } from "react";
import { View, Text, StyleSheet } from "react-native";
import { Bar } from "react-native-pathjs-charts";
import ApiClient from "../../Utils/ApiClient";
// create a component
class Chart extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data: [[{ v: 0, name: "loading" }]]
    };
    this.fetchData();
  }

  static navigationOptions = ({ navigation }) => ({
    title: "Details",
    headerStyle: { backgroundColor: "#2c3e50" },
    headerTitleStyle: { color: "white" }
  });

  fetchData = async () => {
    ApiClient.fetchBooks().then(books => {
      var items = [];
      for (let b of books) {
        console.log(b);
        if (
          !items.some(
            item => item[0].name === b.author.firstName + " " + b.author.lastName
          )
        ) {
          items.push([{
            name: b.author.firstName + " " + b.author.lastName,
            v: 1
          }]);
          console.log(
            "Adding author with name " +
              b.author.firstName +
              " " +
              b.author.lastName
          );
        } else {
          var a = items.find(item => {
            return item[0].name === b.author.firstName + " " + b.author.lastName;
          })[0];
          
          a.v = a.v + 1;
          
        }
      }
      this.setState({ data: items });
    })
    .catch(function(error){console.log(error)});
  };

  render() {
    let options = {
      width: 300,
      height: 300,
      margin: {
        top: 20,
        left: 25,
        bottom: 50,
        right: 20
      },
      color: "#2980B9",
      gutter: 20,
      animate: {
        type: "oneByOne",
        duration: 200,
        fillTransition: 3
      },
      axisX: {
        showAxis: true,
        showLines: true,
        showLabels: true,
        showTicks: true,
        zeroAxis: false,
        orient: "bottom",
        label: {
          fontFamily: "Arial",
          fontSize: 8,
          fontWeight: true,
          fill: "white",
          rotate: 45
        }
      },
      axisY: {
        showAxis: true,
        showLines: true,
        showLabels: true,
        showTicks: true,
        zeroAxis: false,
        orient: "left",
        label: {
          fontFamily: "Arial",
          fontSize: 8,
          fontWeight: true,
          fill: "white"
        }
      }
    };

    return (
      <View style={styles.container}>
        <Bar data={this.state.data} options={options} accessorKey="v" />
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
  }
});

//make this component available to the app
export default Chart;
