// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

struct Campanha {
    address autor;
    string titulo;
    string descricao;
    string videoUrl;
    string imageUrl;
    uint256 saldo;
    bool ativo;
}

contract CampanhasDeDoacao {
    uint256 public taxa = 10000; 
    uint256 public proxId = 0;

    mapping(uint256 => Campanha) public campanhas;

    function addCampanha(string calldata titulo, string calldata descricao, string calldata videoUrl, string calldata imageUrl) public {
        Campanha memory newCampanha;
        newCampanha.titulo = titulo;
        newCampanha.descricao = descricao;
        newCampanha.videoUrl = videoUrl;
        newCampanha.imageUrl = imageUrl;
        newCampanha.ativo = true;
        newCampanha.autor = msg.sender;

        proxId++;
        campanhas[proxId] = newCampanha;
    }

    function doacao(uint256 id) public payable {
        require(msg.value > 0, "The value must be greater than zero");
        require(campanhas[id].ativo == true, "Closed Campaing");

        campanhas[id].saldo += msg.value;
    }

    function saque(uint256 id) public {
        Campanha memory campanha = campanhas[id];
        require(campanha.autor == msg.sender, "No Permission");
        require(campanha.ativo == true, "Closed Campaing");

        address payable recebedor = payable(campanha.autor);
        recebedor.call{value: campanha.saldo - taxa}("");
        campanhas[id].ativo = false;

    }    

}
