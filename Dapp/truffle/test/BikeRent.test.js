const BikeRent = artifacts.require('../contracts/BikeRent.sol')


contract('BikeRent', (accounts) => {
    before(async () => {
    this.BikeRent = await BikeRent.deployed()
    let accounts = await web3.eth.getAccounts()
    var Key

  })

    it('deploys successfully', async () => {
        const address =  await  this.BikeRent.address
        assert.notEqual(address, 0x0)
        assert.notEqual(address, '')
        assert.notEqual(address, null)
        assert.notEqual(address, undefined)
    })

    it('user added ', async () => {
        const result = await this.BikeRent.add_user(accounts[1], 1, 'thor', '123456789', 'thor@asgard.com', '911', {from: accounts[0]})
        const event = result.logs[0].args
        assert.equal(event.usr_id.toNumber(),1)
        assert.equal(event.usr_name,'thor')
            
    /*    it('user Profile modified', async () => {
            const result = await this.BikeRent.edit_profile('new Mail', 'new phone', {from: accounts[1]})
            const event = result.logs[0].args
            assert.equal(event.usr, accounts[1])
        })*/
    })

    it('Bike Added' , async() => {
        const result = await this.BikeRent.add_Bike( 1, 'A', false, 10 , 'bmx')
        const event = result.logs[0].args
        assert.equal(event.id.toNumber(),1)
    })

    it('User removed', async () => {
        const result = await this.BikeRent.Remove_user(accounts[1])
        const event = result.logs[0].args
        assert.equal(event.addr, accounts[1])
    })

    it('Bike removed', async () => {
        const result = await this.BikeRent.delete_Bike(1)
        const event = result.logs[0].args
        assert.equal(event.bike_id , 1)
    })

    it('user  post his bike  For rent', async () => {
        const result = await this.BikeRent.user_post_bike_for_rent()
        const event = result.logs[0].args
        assert.equal(event.state, true)
    })
   
    it('admin post bike for rent', async () => {
        const result = await this.BikeRent.admin_post_bike_for_rent(1)
        const event = result.logs[0].args
        assert.equal(event.bike_id.toNumber(), 1)
        assert.equal(event.state, true)
        assert.equal(event.owner_addr, accounts[0])

    })

/*    it('admin remove bike From rent', async () => {
        const result = await this.BikeRent.admin_remove_From_rent(1,{from : accounts[0]})
        const event = result.logs[0].args
        assert.equal(event.id.toNumber(), 1)

    }) */

/*    it('User Rent a Bike', async () => {
        const result = await this.BikeRent.Rent_Bike(1,10)
        const event = result.logs[0].args
        assert.equal(event.id.toNumber(), 1)

    }) */


 /*   it('stop rent of a bike', async () => {
        const result = await this.BikeRent.stop_rent('A')
        const event = result.logs[0].args
        assert.equal(event.id.toNumber(), 1)

    })*/

    it('generate Key', async () => {
        const result = await this.BikeRent.generate_Key()
        this.key = result

    })


/*    it('open Lock', async () => {
        const result = await this.BikeRent.openLock(1)
        const event = result.logs[0].args
        assert.equal(event.id.toNumber(), 1)
        assert.equal(event.state, false)


    })

    it('close Lock', async () => {
        const result = await this.BikeRent.closeLock(1)
        const event = result.logs[0].args
        assert.equal(event.id.toNumber(), 1)
        assert.equal(event.state, true)
    

    }) */
})